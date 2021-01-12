//
//  ResetPasswordController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/11/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordController: UIViewController {
    
    //MARK: - Properties
    
    private var resetPasswordViewModel = ResetPasswordViewModel()
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "fondwireLogo"))
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField(withPlaceholder: "Email")
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let resetPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.title = "Send Reset Link"
        button.titleLabel?.font = UIFont.gothamMedium(ofSize: 14)
        button.addTarget(self, action: #selector(handleResetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .fwCyan
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    //MARK: - Helpers
    func configureUI() {
        emailTextField.delegate = self
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientBackground()
        view.addSubview(iconImage)
        iconImage.setDimensions(height: 80, width: 80)
        iconImage.centerX(inView: view)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 60)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stackView.spacing = 20
        stackView.axis = .vertical
        view.addSubview(stackView)
         stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingLeft: 16)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.view != emailTextField {
            emailTextField.endEditing(true)
        }
    }
    
    func configureNotificationObservers()  {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    //MARK: - Selectors
    
    @objc func handleResetButtonTapped() {
    }
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        if textField == emailTextField {
            resetPasswordViewModel.email = textField.text
        }
        updateForm()
    }
}

extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resetPasswordButton.isEnabled = resetPasswordViewModel.shouldEnableButton
        resetPasswordButton.setTitleColor(resetPasswordViewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.backgroundColor = resetPasswordViewModel.buttonBackgroundColor
    }
}

extension ResetPasswordController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
    }
}
