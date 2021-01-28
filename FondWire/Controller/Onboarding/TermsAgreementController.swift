//
//  TermsAgreementController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/15/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

protocol TermsAgreementControllerDelegate: class {
    func didAgreeToTerms()
}

class TermsAgreementController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: TermsAgreementControllerDelegate?
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "horizontal_logo"))
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          NSAttributedString.Key.font: UIFont.gothamThin(ofSize: 14),
                          NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.90)]
        
        textView.attributedText = NSAttributedString(string: AGREEMENT_TEXT, attributes:attributes)
        return textView
    }()
    
    private let readDisclosrBttn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Read our full Legal Disclosures here.", for: .normal)
        button.titleLabel?.font = .gothamLight(ofSize: 14)
        button.tintColor = UIColor.fwYellow
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleReadDiscolsrTapped), for: .touchUpInside)
        return button
    }()
    
    private let iAgreeLabel: UILabel = {
        let label = UILabel()
        label.font = .gothamLight(ofSize: 12)
        label.text = "   I agree to the Terms and Conditions"
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let iAgreeSwitch: UISwitch = {
          let switchControl = UISwitch()
          switchControl.onTintColor = .fwYellow
          switchControl.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
          switchControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
          return switchControl
      }()
    
    
    private let iConfirmLabel: UILabel = {
        let label = UILabel()
        label.font = .gothamLight(ofSize: 12)
        label.text = "   I confirm to be a professional Investor"
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let iConfirmSwitch: UISwitch = {
          let switchControl = UISwitch()
          switchControl.onTintColor = .fwYellow
          switchControl.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
          switchControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
          return switchControl
      }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CONTINUE", for: .normal)
        button.titleLabel?.font = .gothamBold(ofSize: 16)
        button.tintColor = UIColor.black
        button.backgroundColor = .fwFeedDarkBlue
        button.contentHorizontalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleContinueTapped), for: .touchUpInside)
        return button
    }()



    //MARK: - Lifecycle

    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            UIView.animate(withDuration: 1) {
                self.iAgreeSwitch.setOn(true, animated: true)
                self.iConfirmSwitch.setOn(true, animated: true)
//            }
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            UIView.animate(withDuration: 0.5) {
                self.iAgreeSwitch.setOn(false, animated: true)
                self.iConfirmSwitch.setOn(false, animated: true)
//                }
                
                
            }
        }
    }
    override func viewDidLoad() {
        super .viewDidLoad()
        
        configureUI()
    }
 
    //MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .fwDarkBlueBg
        navigationController?.navigationBar.isHidden = true
        setNeedsStatusBarAppearanceUpdate()
        
        view.addSubview(iconImage)
        iconImage.setDimensions(height: 100, width: 200)
        iconImage.contentMode = .scaleAspectFit
        iconImage.centerX(inView: view)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 40)
        
        let stackView = UIStackView(arrangedSubviews: [textView, readDisclosrBttn])
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.centerX(inView: view)
        stackView.anchor(top: iconImage.bottomAnchor, paddingTop: 20)
        stackView.setDimensions(height: view.frame.height/3.9, width: view.frame.width * 0.85)
        readDisclosrBttn.setDimensions(height: 20, width: view.frame.width * 0.85)
        
        
        let iAgreeView = UIView()
        iAgreeView.backgroundColor = .fwDarkBlueBg
        iAgreeView.setDimensions(height: view.frame.height * 0.07, width: view.frame.width * 0.85)
        iAgreeView.addSubview(iAgreeLabel)
        iAgreeView.addSubview(iAgreeSwitch)
        iAgreeLabel.centerY(inView: iAgreeView, leftAnchor: iAgreeView.leftAnchor, paddingLeft: 20, constant: 0)
        iAgreeSwitch.centerY(inView: iAgreeView, rightAnchor: iAgreeView.rightAnchor, paddingRight: 20, constant: 0)

        
        let iConfirmView = UIView()
        iConfirmView.backgroundColor = .fwDarkBlueBg
        iConfirmView.setDimensions(height: view.frame.height * 0.07, width: view.frame.width * 0.85)
        iConfirmView.addSubview(iConfirmLabel)
        iConfirmView.addSubview(iConfirmSwitch)
        iConfirmLabel.centerY(inView: iConfirmView, leftAnchor: iConfirmView.leftAnchor, paddingLeft: 20, constant: -10)
        iConfirmSwitch.centerY(inView: iConfirmView, rightAnchor: iConfirmView.rightAnchor, paddingRight: 20, constant: -10)
        
        let lineView = UIView()
        lineView.setDimensions(height: 0.25, width: view.frame.width)
        lineView.backgroundColor = .init(white: 0.7, alpha: 1)
        lineView.alpha = 0.5
        
        let bottomElementsStackView = UIStackView(arrangedSubviews: [lineView, iAgreeView, iConfirmView, continueButton])
        bottomElementsStackView.backgroundColor = .fwDarkBlueBg
        bottomElementsStackView.axis = .vertical
        view.addSubview(bottomElementsStackView)
        bottomElementsStackView.centerX(inView: view)
        bottomElementsStackView.anchor(bottom: view.bottomAnchor)
        bottomElementsStackView.setDimensions(height: view.frame.height * 0.25, width: view.frame.width)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    //MARK: - Selectors
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if iAgreeSwitch.isOn && iConfirmSwitch.isOn {
            UIView.animate(withDuration: 0.5) {
            self.continueButton.isEnabled = true
            self.continueButton.backgroundColor = .yellow
            }
        } else {
            UIView.animate(withDuration: 0.5) {
            self.continueButton.isEnabled = false
            self.continueButton.backgroundColor = .fwFeedDarkBlue
            }
        }
    }
    
    @objc func handleReadDiscolsrTapped() {}

    @objc func handleContinueTapped() {
        
        dismiss(animated: false) {
            self.delegate?.didAgreeToTerms()
            Vibration.rigid.vibrate()

        }
        
    }
}
