//
//  WKWebViewController.swift
//  FondWire
//
//  Created by Edil Ashimov on 8/2/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WKWebViewContoller: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: String! = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: url)!))
        webView.allowsBackForwardNavigationGestures = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        hud.dismiss()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        hud.show(in: webView, animated: true)
    }
    
}
