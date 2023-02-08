//
//  FeedDetailController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/30/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

private let reuseID = "feedDetailReuseID"

class FeedDetailController: UICollectionViewController {
    
    let feed: Feed
    
    init(feed: Feed) {
        self.feed = feed
        super.init(collectionViewLayout: UICollectionViewFlowLayout())


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.compactAppearance?.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI()  {
        collectionView.backgroundColor = .white
        collectionView.register(FeedDetailCollectionViewCell.self, forCellWithReuseIdentifier: reuseID)
    }
    
}

extension FeedDetailController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! FeedDetailCollectionViewCell
        cell.feed = feed
        return cell
    }
}
extension FeedDetailController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = FeedViewModel(feed: feed)
        var height = viewModel.sizeForDetail(forWidth: view.frame.width, for: viewModel.detailBodyText?.string ?? "").height
        switch feed.type {
            case .article: height += 270
            case .video: height += 270
            case .podcast: print("")
            case .event: height += 70
            }
        return CGSize(width: view.frame.width * 0.95, height: height)


      }
}
