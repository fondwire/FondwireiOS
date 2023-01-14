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

class FWWebViewContoller: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard var urlString = url else { return }
        if !urlString.starts(with: "http://") {
            urlString = "http://" + urlString
        }
        guard let url = URL(string: urlString)
        else { return incorrectUrlProvided() }

        webView.load(URLRequest(url: url))
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
    
    func incorrectUrlProvided() {
        FWAlert.present(withTitle: "Failed to Load", andMessage: "The URL is broken, or you have data connection issues. Try Again Later!", buttons: [.ok])
    }
    
}
