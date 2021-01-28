//
//  WelcomeController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/16/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

protocol WelcomeControllerDelegate: class {
    func welcomeViewDismissed()
}

class WelcomeController: UIViewController {
    
    weak var delegate: WelcomeControllerDelegate?

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.alignment = .center
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          NSAttributedString.Key.font: UIFont.gothamLight(ofSize: 16),
                          NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1)]
        
        label.attributedText = NSAttributedString(string: "WELCOME TO FONDWIRE", attributes:attributes)
        return label
    }()
    
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "fondwireLogo"))
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.alignment = .center
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          NSAttributedString.Key.font: UIFont.gothamThin(ofSize: 14),
                          NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1)]
        
        textView.attributedText = NSAttributedString(string: WELCOME_TEXT, attributes:attributes)
        return textView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LET'S START", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .gothamBold(ofSize: 14)
        button.backgroundColor = .fwYellow
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleStartTapped), for: .touchUpInside)
        return button
    }()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Vibration.error.vibrate()
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        view.backgroundColor = .fwDarkBlueBg
        iconImage.setDimensions(height: 80, width: 80)
        welcomeLabel.setDimensions(height: 120, width: 140)
        welcomeLabel.anchor(paddingTop: 50)
        textView.setDimensions(height: 200, width: view.frame.width * 0.60)
        
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, iconImage, textView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 130)
        stackView.setDimensions(height: view.frame.height * 0.50, width: view.frame.width * 0.75)
        stackView.addBackground(color: .fwDarkBlueBg, withBorderColor: .fwYellow, borderHeight: 0.15, andCornerRadius: view.frame.height * 0.5/15)
        
        view.addSubview(startButton)
        startButton.centerX(inView: view)
        startButton.setDimensions(height: 50, width: view.frame.width * 0.75)
        startButton.anchor(bottom: view.bottomAnchor, paddingBottom: 140)
    }
    
    //MARK: - Selector
    
    @objc func handleStartTapped() {
        
        let controller = OnboardingController()
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        controller.delegate = self
        present(controller, animated: true, completion: nil)

       
    }
}

extension WelcomeController: OnboardingControllerDelegate {
    func onboardingWasSeen() {
        dismiss(animated: false) {
            self.dismiss(animated: false, completion: {
                self.delegate?.welcomeViewDismissed()
            })
        }
    }
    
    
}
