//
//  AppDelegate.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/9/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorBackground = .white
        ProgressHUD.colorAnimation = .fwYellow
        fetchFeeds()
        fetchAssets()
        setNavigationBarAppearance()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func fetchAssets() {
        AssetService.shared.fetchAssets { (assets) in
            DataService.shared.assets = assets
        }
    }
    
    func fetchFeeds()  {
        FeedService.shared.fetchFeed { (feed) in
            DataService.shared.feeds = feed
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "feedsFetched"), object: nil)
        }
    }
    
    func setNavigationBarAppearance() {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .black 
    }
    
    func fetchUser() {
        if Auth.auth().currentUser != nil {
            UserService.shared.fetchUser(uid: Auth.auth().currentUser!.uid) { (user) in
                DataService.shared.currentUser = user
            }
        }
    }
}

