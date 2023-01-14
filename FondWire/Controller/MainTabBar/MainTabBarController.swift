//
//  MainTabBarController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/15/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import SwiftyGif


class MainTabBarController: UITabBarController {
    
    //MARK: - Properties

    var user: User?
    let logoAnimationView = LogoAnimationView()

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
        if !logoAnimationView.isHidden {
            startVibration()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.startVibration()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.startVibration()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                self.startVibration()
            }
        }
    }

    func startVibration() {
        Vibration.error.vibrate()
    }
    
    
    //MARK: - Helpers
    func authenticateUserAndConfUI() {
        configureViewControllers()
        configureUI()
    }
    
    fileprivate func logOutUsr()  {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Successfully signed out")

        } catch {
            print("DEBUG: Error:\(error)")
        }
    }

    func configureUI() {
        navigationController?.navigationBar.barStyle = .default
        view.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.tintColor = .fwDarkBlueBg
        tabBar.barStyle = .default
    }

    
    func configureViewControllers() {
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "FeedController", bundle: nil)
        let feedController : UIViewController = mainView.instantiateViewController(withIdentifier: "FeedController") as! FeedController
        let feedNav = embedInNav(image: #imageLiteral(resourceName: "feedicon"), viewController: feedController)
        
        
        let favoriteNav = embedInNav(image: #imageLiteral(resourceName: "favoriteIcon"), viewController: FavoritesController())
        
        let assetNav = embedInNav(image: #imageLiteral(resourceName: "assetmanagericon"), viewController: AssetManagerController())
        let messagesNav = embedInNav(image: #imageLiteral(resourceName: "messagesicon"), viewController: MessagesController())

        let profileNav = embedInNav(image: #imageLiteral(resourceName: "profileicon"), viewController: ProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        viewControllers = [feedNav, favoriteNav, assetNav, messagesNav, profileNav]
    }
    
    func embedInNav(image: UIImage?, viewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.image = image
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.gothamBold(ofSize: 16)]
        setNavigationBarAppearance()
        return nav
    }
    
    func setNavigationBarAppearance() {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Vibration.light.vibrate()

    }
    
    
    //MARK: - Selectors

}

extension MainTabBarController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
                self.authenticateUserAndConfUI()
    }
}
