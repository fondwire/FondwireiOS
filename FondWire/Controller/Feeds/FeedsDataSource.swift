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
    private var isFavorites = false
    let refreshControl = UIRefreshControl()
    
    init(collectionView: UICollectionView, forFavorites: Bool = false) {
        super.init()
        self.collectionView = collectionView
        self.collectionView.dataSource = self
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(reloadCollectionData), for: .valueChanged)
           collectionView.refreshControl = refreshControl
           collectionView.alwaysBounceVertical = true
        isFavorites = forFavorites
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
         if isFavorites {
             return DataService.shared.favoritedFeeds!.count

         } else {
             return DataService.shared.feeds!.count

         }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var feed: Feed?
        
        if isFavorites {
            feed = DataService.shared.favoritedFeeds![indexPath.row]
        } else {
            feed = DataService.shared.feeds![indexPath.row]
        }
        
        
        switch feed!.type {
        case .article:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleView", for: indexPath) as! ArticleCell
            cell.feed = feed
            cell.playButton.isHidden = true

            return cell
        case .video:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleView", for: indexPath) as! ArticleCell
            cell.feed = feed
            cell.playButton.isHidden = false
            return cell
        case .podcast:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleView", for: indexPath) as! ArticleCell
            cell.feed = feed
            return cell

        case .event:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedEventView", for: indexPath) as! FeedEventCell
            cell.feed = feed
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }
    }
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
