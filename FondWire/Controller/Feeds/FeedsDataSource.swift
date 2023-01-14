//
//  FeedsDataSource.swift
//  FondWire
//
//  Created by Edil Ashimov on 12/13/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit

class FeedsDataSource: NSObject, UICollectionViewDataSource {

    private var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()
    
    
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        self.collectionView.dataSource = self
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(reloadCollectionData), for: .valueChanged)
           collectionView.refreshControl = refreshControl
           collectionView.alwaysBounceVertical = true
    }
    
    @objc func reloadCollectionData() {
         collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
        

     }
    deinit {
        print("TestVC Deinit")
    }
    
}


extension FeedsDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.shared.feeds!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let feed = DataService.shared.feeds![indexPath.row]
        switch feed.type {
        case .article:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleView", for: indexPath) as! ArticleCell
            cell.feed = feed
            return addShadowToCell(cell)
        case .video:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedVideoView", for: indexPath) as! FeedVideoCell
            cell.feed = feed
            cell.delegate = self
            return addShadowToCell(cell)

        case .podcast:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedVideoView", for: indexPath) as! FeedVideoCell
            cell.feed = feed
            return addShadowToCell(cell)

        case .event:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedEventView", for: indexPath) as! FeedEventCell
            cell.feed = feed
            cell.indexPath = indexPath
            cell.delegate = self
            return addShadowToCell(cell)
        }
    }
}

private func addShadowToCell(_ cell: UICollectionViewCell) -> UICollectionViewCell {
    cell.contentView.isUserInteractionEnabled = false
    cell.contentView.layer.cornerRadius = 2.0
    cell.contentView.layer.borderWidth = 1.0
    cell.contentView.layer.borderColor = UIColor.clear.cgColor
    cell.contentView.layer.masksToBounds = true
    
    cell.layer.backgroundColor = UIColor.white.cgColor
    cell.layer.shadowColor = UIColor.gray.cgColor
    cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)//CGSizeMake(0, 2.0);
    cell.layer.shadowRadius = 2.0
    cell.layer.shadowOpacity = 1.0
    cell.layer.masksToBounds = false
    cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
    
    return cell
}

extension FeedsDataSource: EventCellDelegate {
    func dismissTapped(for cell: FeedEventCell) {
        collectionView.performBatchUpdates {
            DataService.shared.feeds?.remove(at: cell.indexPath!.row)
            self.collectionView.reloadData()
        }
    }
}

extension FeedsDataSource: FeedVideoCellDelegate {
    func archiveTapped(archived: Bool) {
        print("\(archived)")
    }

}
