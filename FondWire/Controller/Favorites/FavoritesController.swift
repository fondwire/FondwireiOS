//
//  FavoritesController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/15/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import FirebaseAuth
import ProgressHUD

class FavoritesController: UICollectionViewController {
    
    //MARK: - Properties
    var webView = WKWebView()
    var dataSource: FeedsDataSource?
    
    private let filterBarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.addTarget(self, action: #selector(handleFilterTapped), for: .touchUpInside)
        button.tintColor = .darkGray
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userUpdatedFromFeed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionView), name: NSNotification.Name(rawValue: "feedsFetched"), object: nil)
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        configureUI()
        updateCollectionView()
    }
    
    @objc func updateCollectionView()  {
//        guard let feeds = DataService.shared.feeds else { return }

        dataSource = FeedsDataSource(collectionView: collectionView, forFavorites: true)
        collectionView.dataSource = dataSource
    }
    
    //MARK: - Helpers
    func configureUI() {
        let barButton = UIBarButtonItem(customView: filterBarButton)
        navigationItem.rightBarButtonItem = barButton
        
        let feedEventNib = UINib.init(nibName: "FeedEventView", bundle: nil)
        collectionView.register(feedEventNib, forCellWithReuseIdentifier: "FeedEventView")
        
        let feedArticleNib = UINib.init(nibName: "ArticleView", bundle: nil)
        collectionView.register(feedArticleNib, forCellWithReuseIdentifier: "ArticleView")
        
        setNeedsStatusBarAppearanceUpdate()
        navigationItem.title = "FAVORITES"
        collectionView.showsVerticalScrollIndicator = false
    }
    
    
    //MARK: - Selectors
    @objc func handleFilterTapped() {
        comingSoon()
    }
    
    func presentLoginController()  {
        let controller = LoginController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func presentFeedDetailController(withFeed feed: Feed) {
        let detailController = FeedDetailController(feed: feed)
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func presentWebController(withUrl url: String)  {
        let webViewController = FWWebViewContoller()
        webViewController.url = url
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func registerFeedTapped() {
        
    }
    
}

// MARK: - UICollectionViewDataSource/Delegate
extension FavoritesController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        guard Auth.auth().currentUser != nil else { return presentLoginController() }
        guard let feeds = DataService.shared.favoritedFeeds else { return }
        
        let feed = feeds[indexPath.row]
        
        if feed.type == .event {
            guard let url = feed.url else { return }
            presentWebController(withUrl: url)
        } else {
            presentFeedDetailController(withFeed: feed)
        }
    }
    
}
//
//// MARK: UICollectionViewDelegateFlowLayout
extension FavoritesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let feeds = DataService.shared.favoritedFeeds else { return CGSize.zero }

        let feed = feeds[indexPath.row]
        switch feed.type {
        case .event:
            return CGSize.zero
        default: ()
        }
        
        return CGSize(width: view.frame.width, height: 150)
    }
}

extension FavoritesController: CompanyInfoControllerDelegate {
    func companyDidSpecified() {
    }
}

extension FavoritesController: LoginControllerDelegate {
    func loginCompleted() {
        collectionView(collectionView, didSelectItemAt: selectedIndexPath)
    }
}
