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
import ProgressHUD

class FWWebViewContoller: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: String?

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard var urlString = url else { return }
        guard let url = URL(string: urlString)
        else { return incorrectUrlProvided() }

        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        tabBarController?.tabBar.isHidden = true
        ProgressHUD.show()

    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ProgressHUD.show()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.dismiss()
    }
    
    func incorrectUrlProvided() {
        FWAlert.present(withTitle: "Failed to Load", andMessage: "The URL is broken, or you have data connection issues. Try Again Later!", buttons: [.ok])
    }
    
}
