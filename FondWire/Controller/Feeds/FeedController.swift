//
//  FeedController.swift
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

var selectedIndexPath = IndexPath()
class FeedController: UICollectionViewController {
    
    //MARK: - Properties    
    var webView = WKWebView()
    var dataSource: FeedsDataSource?
    
    private let filterBarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.addTarget(self, action: #selector(handleFilterTapped), for: .touchUpInside)
        button.tintColor = .fwYellow
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userUpdatedFromFeed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionView), name: NSNotification.Name(rawValue: "feedsFetched"), object: nil)
        presentOnboardingController()
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        configureUI()
        updateCollectionView()
    }
    @objc func updateCollectionView()  {
        guard let feeds = DataService.shared.feeds else { return }
        dataSource = FeedsDataSource(collectionView: collectionView)
        collectionView.dataSource = dataSource
    }
    
    //MARK: - Helpers
    func configureUI() {
        let barButton = UIBarButtonItem(customView: filterBarButton)
        navigationItem.rightBarButtonItem = barButton
        let feedVideoNib = UINib.init(nibName: "FeedVideoView", bundle: nil)
        collectionView.register(feedVideoNib, forCellWithReuseIdentifier: "FeedVideoView")
        
        let feedEventNib = UINib.init(nibName: "FeedEventView", bundle: nil)
        collectionView.register(feedEventNib, forCellWithReuseIdentifier: "FeedEventView")
        
        let feedArticleNib = UINib.init(nibName: "ArticleView", bundle: nil)
        collectionView.register(feedArticleNib, forCellWithReuseIdentifier: "ArticleView")
        
        setNeedsStatusBarAppearanceUpdate()
        collectionView.backgroundColor = .fwFeedBackground
        navigationItem.title = "ALL FEEDS"
        collectionView.showsVerticalScrollIndicator = true
    }
    
    func presentOnboardingController()  {
        if defaults.bool(forKey: "onboardingPresented") == false {
            let controller = WelcomeController()
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .fullScreen
            controller.delegate = self
            present(controller, animated: true)
            defaults.set(true, forKey: "onboardingPresented")
            
            do {
                try Auth.auth().signOut()
            } catch {
                
            }
            
            let defaultAssets = ["Fondwire", "Codex"]
            let userPreferences = ["selectedAssets": defaultAssets]
            let userInfo = ["notUser": userPreferences]
            UserDefaults.standard.set(userInfo, forKey: "userInfo")
        } 
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

extension FeedController: WelcomeControllerDelegate {
    func welcomeViewDismissed() {
        if defaults.bool(forKey: "userLoggedIn") == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                let controller = AssetManagerController()
                controller.modalPresentationStyle = .formSheet
                let nav = UINavigationController(rootViewController: controller)
                nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.gothamBold(ofSize: 16)]
                self.present(nav, animated: true, completion: nil)
            }
            defaults.set(true, forKey: "userLoggedIn")
        }
    }
}

// MARK: - UICollectionViewDataSource/Delegate
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        guard Auth.auth().currentUser != nil else { return presentLoginController() }
        guard let feeds = DataService.shared.feeds else { return }
        
        let feed = feeds[indexPath.row]
        
        if feed.type == .event {
            guard let url = feed.url else { return }
            presentWebController(withUrl: url)
        } else {
            presentFeedDetailController(withFeed: feed)
        }
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let feeds = DataService.shared.feeds else { return CGSize.zero}
        
        let viewModel = FeedViewModel(feed: feeds[indexPath.row])
        
        let feed = feeds[indexPath.row]
        let textFrame = viewModel.size(forWidth: collectionView.frame.width, withbodyText: feed.attrBody ?? feed.attrTeaser ?? NSMutableAttributedString(), andTitle: feed.title, forFeedType: feed.type)
        
        return CGSize(width: collectionView.frame.width, height: textFrame.height)
    }
}

extension FeedController: CompanyInfoControllerDelegate {
    func companyDidSpecified() {
    }
}

extension FeedController: LoginControllerDelegate {
    func loginCompleted() {
        collectionView(collectionView, didSelectItemAt: selectedIndexPath)
    }
}
