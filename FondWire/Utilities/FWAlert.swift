//
//  FWAlert.swift
//  FondWire
//
//  Created by Edil Ashimov on 5/15/21.
//  Copyright © 2021 Edil Ashimov. All rights reserved.
//

import UIKit

public struct FWAlert {
    
    public enum Button {
        
        case ok
        case retry
        case cancel
        
        public var title: String? {
            switch self {
            case .ok: return "Ok"
            case .retry: return "Retry"
            case .cancel: return "Cancel"
            }
        }
        
    }
    
    static func present(withTitle title: String, andMessage message: String, buttons: [FWAlert.Button], _ buttonAction: ((FWAlert.Button) -> ())? = nil) {
        let title: String? = title
        let message: String? = message
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for button in buttons {
            switch button {
            case .ok:
                let okButton: UIAlertAction = UIAlertAction(title: FWAlert.Button.ok.title, style: .default) { (_) in
                    buttonAction?(.ok)
                }
                alert.addAction(okButton)
                
            case .retry:
                let retryButton: UIAlertAction = UIAlertAction(title: FWAlert.Button.retry.title, style: .default) { (_) in
                    buttonAction?(.retry)
                }
                alert.addAction(retryButton)
                
            case .cancel:
                let cancelButton: UIAlertAction = UIAlertAction(title: FWAlert.Button.cancel.title, style: .default) { (_) in
                    buttonAction?(.cancel)
                }
                alert.addAction(cancelButton)
            }
        }
        
        present(alert: alert)
    }

    private static func present(alert: UIAlertController, animated: Bool = true) {
        guard let topViewController: UIViewController = UIApplication.topViewController() else { return }
        if !topViewController.isKind(of: UIAlertController.self) {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Dismisses any currently displayed UIAlertController's.
    /// Passing an `errorCode` value will only dismiss UIAlertController's with that specific `errorCode` value.
    /// `errorCode` is `nil` by default.
    ///
    /// - Parameter errorCode: Dismisses a UIAlertController with a specific `errorCode` value.
    static func dismiss(errorCode: Int? = nil) {
        guard let topViewController: UIViewController = UIApplication.topViewController() else { return }
        if topViewController.isKind(of: UIAlertController.self) {
            if topViewController.view.tag == errorCode {
                topViewController.dismiss(animated: false)
            }
            else if errorCode == nil {
                topViewController.dismiss(animated: false)
            }
        }
    }
    
}

