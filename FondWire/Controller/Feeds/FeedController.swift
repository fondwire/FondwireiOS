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
    var user: User?
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
        fetchUser()
        updateCollectionView()
    }
    
     //MARK: - API
    func fetchUser() {
        if Auth.auth().currentUser != nil {
            UserService.shared.fetchUser(uid: Auth.auth().currentUser!.uid) { (user) in
                self.user = user
            }
        }
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
    
    func presentCompanyInfoController() {
        let controller = CompanyInfoController()
        controller.delegate = self
        controller.user =  user
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func presentFeedDetailController(withFeed feed: Feed) {
        let detailController = FeedDetailController(feed: feed)
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func presentWebController(withUrl url: String)  {
        let webViewController = WKWebViewContoller()
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
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
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
}

// MARK: UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let feeds = DataService.shared.feeds else { return CGSize(width: 0, height: 0) }
        
        let viewModel = FeedViewModel(feed: feeds[indexPath.row])
        
        let feed = feeds[indexPath.row]
        var height = viewModel.size(forWidth: view.frame.width).height
        var width = view.frame.width
        
        switch feed.type {
        case .article: height += 240
        case .video: height += 290
        case .podcast: print("")
        case .event: height += 170
        }
        if feed.type == .event {
            width *= 0.95
        }
        return CGSize(width: width, height: height)
    }
}

extension FeedController: CompanyInfoControllerDelegate {
    func companyDidSpecified() {
        fetchUser()
    }
}

extension FeedController: LoginControllerDelegate {
    func loginCompleted() {
        collectionView(collectionView, didSelectItemAt: selectedIndexPath)
        fetchUser()
    }
}

