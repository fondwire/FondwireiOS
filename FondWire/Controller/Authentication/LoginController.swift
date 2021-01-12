//
//  ViewController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/9/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit
import Foundation
import ProgressHUD

protocol LoginControllerDelegate: class {
    func loginCompleted()
}

class LoginController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: LoginControllerDelegate?
    private var loginViewModel = LoginViewModel()
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "fondwireLogo"))
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField(withPlaceholder: "Email")
        textField.autocapitalizationType = .none
        return textField
       }()
    
    private let passwordTextfield: UITextField = {
        let textfield = CustomTextField(withPlaceholder: "Password")
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.title = "Login"
        button.addTarget(self, action: #selector(handleLoginTapped), for: .touchUpInside)
        button.titleLabel?.font = .gothamMedium(ofSize: 14)
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(white: 0.8, alpha: 1)
        button.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
        button.setDimensions(height: 40, width: 40)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.gothamLight(ofSize: 10)]
        var attributedTitle = NSMutableAttributedString(string: "Forgot your password?", attributes: attr)
        
        let boldAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.gothamMedium(ofSize: 10)]
        
        attributedTitle.append(NSAttributedString(string: " Get help signing in.", attributes: boldAttr))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleForgotPasswordTapped), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.gothamLight(ofSize: 10)]
        var attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: attr)
        
        let boldAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.gothamMedium(ofSize: 10)]
        
        attributedTitle.append(NSAttributedString(string: " Sign Up", attributes: boldAttr))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleDontHaveAnAccountTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
        
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationItem.hidesBackButton = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        emailTextField.delegate = self
        passwordTextfield.delegate = self
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientBackground()
        view.addSubview(iconImage)
        iconImage.setDimensions(height: 80, width: 80)
        iconImage.centerX(inView: view)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 60)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextfield, loginButton, forgotPasswordButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.setCustomSpacing(30, after: passwordTextfield)
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAnAccountButton)
        dontHaveAnAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom:view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 50)
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 15, paddingRight: 10)
        
    }
    
    func configureNotificationObservers()  {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

    }
    
    // Manage keyboard and tableView visibility
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch:UITouch = touches.first else { return }
        if touch.view != emailTextField || touch.view != passwordTextfield  {
            emailTextField.endEditing(true)
            passwordTextfield.endEditing(true)
        }
    }
    
    //MARK: - Selectors
    
    @objc func handleLoginTapped() {
        ProgressHUD.show("Loging In")
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextfield.text else { return }
        AuthService.shared.signUserIn(email: email, password: password) { (result, error) in
            if let error = error {
                ProgressHUD.showError("\(error.localizedDescription)", interaction: true)
            } else {
                self.dismiss(animated: true) {
                    ProgressHUD.dismiss()
                    self.delegate?.loginCompleted()
                }
            }
        }
        
    }
    
    
    @objc func handleDismissTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleForgotPasswordTapped() {
        let controller = ResetPasswordController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleDontHaveAnAccountTapped() {
        let controller = SignUpController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
        updateForm()
    }
}

extension LoginController: FormViewModel{
    func updateForm() {
        loginButton.isEnabled = loginViewModel.shouldEnableButton
        loginButton.setTitleColor(loginViewModel.buttonTitleColor, for: .normal)
        loginButton.backgroundColor = loginViewModel.buttonBackgroundColor
    } 
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
            passwordTextfield.becomeFirstResponder()
        } else if textField == passwordTextfield {
            passwordTextfield.resignFirstResponder()
            loginButton.becomeFirstResponder()
        }
        return true
    }
}

extension LoginController: SignUpControllerDelegate {
    func registrationComplete() {
        dismiss(animated: true) {
            self.delegate?.loginCompleted()
        }
    }
    
    
}
