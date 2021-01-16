//
//  SignUpController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/10/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import ProgressHUD

protocol SignUpControllerDelegate: class {
    func registrationComplete()
}

class SignUpController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: SignUpControllerDelegate?
    private var signUpViewModel = SignUpViewModel()
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "fondwireLogo"))
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField(withPlaceholder: "Email")
        textField.autocapitalizationType = .none
        return textField
        }()
    
    private let fullNameTextField = CustomTextField(withPlaceholder: "Fullname")

    private let passwordTextfield: UITextField = {
        let textfield = CustomTextField(withPlaceholder: "Password")
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    private let confirmPasswordTextfield: UITextField = {
        let textfield = CustomTextField(withPlaceholder: "Confirm Password")
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.title = "Sign Up"
        button.addTarget(self, action: #selector(handleSignUpTapped), for: .touchUpInside)
        button.titleLabel?.font = .gothamMedium(ofSize: 14)
        return button
    }()

    private let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
          
          let attr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.gothamLight(ofSize: 10)]
          var attributedTitle = NSMutableAttributedString(string: "Already Have An Account? ", attributes: attr)
          
          let boldAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.gothamMedium(ofSize: 10)]
          
          attributedTitle.append(NSAttributedString(string: " Sign In", attributes: boldAttr))
          button.setAttributedTitle(attributedTitle, for: .normal)
          button.addTarget(self, action: #selector(handleAlreadyHaveAnAccountTapped), for: .touchUpInside)

        return button
    }()
    
    private let assetManagerLabel: UILabel = {
        let label = UILabel()
        label.text = "I am an Asset Manager"
        label.font = UIFont.gothamBook(ofSize: 12)
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.textAlignment = .left
        return label
    }()
    
    private let assetManagerSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.tintColor = .yellow
        switchControl.onTintColor = .fwYellow
        switchControl.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        switchControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
        return switchControl
    }()
    
    private let backButton: UIButton = {
          let button = UIButton(type: .system)
          button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
          button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
          button.tintColor = .fwYellow
          return button
      }()
    
    
    var values: [String: AnyObject]?

    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
        fullNameTextField.becomeFirstResponder()
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
        let nav = UINavigationController(rootViewController: CompanyInfoController())
        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientBackground()
        
        view.addSubview(iconImage)
        iconImage.setDimensions(height: 80, width: 80)
        iconImage.centerX(inView: view)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 60)
        
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextfield, confirmPasswordTextfield, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution  = .fillProportionally
        
        view.addSubview(stackView)
        stackView.setCustomSpacing(30, after: confirmPasswordTextfield)
        

        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom:view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 50)
       
        let assetManagerStackView = UIStackView(arrangedSubviews: [assetManagerLabel, assetManagerSwitch])
        view.addSubview(assetManagerStackView)
        assetManagerStackView.axis = .horizontal
        assetManagerStackView.distribution = .fillProportionally
        assetManagerStackView.anchor(top: stackView.bottomAnchor, paddingTop: 25, width: 200, height: 30)
        assetManagerStackView.centerX(inView: view)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        passwordTextfield.delegate = self
        confirmPasswordTextfield.delegate = self

        }
  
    
    func configureNotificationObservers()  {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        confirmPasswordTextfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         guard let touch = touches.first else { return }
         if touch.view != emailTextField ||
            touch.view != fullNameTextField ||
            touch.view != passwordTextfield ||
            touch.view != confirmPasswordTextfield {
             view.endEditing(true)
         }
     }

    //MARK: - Selectors
    @objc func switchValueDidChange(_ sender: UISwitch) {
        
    }
    
    @objc func handleDismissal() {
         navigationController?.popViewController(animated: true)
     }
    
    @objc func handleSignUpTapped() {

        ProgressHUD.show("Singing Up")
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextfield.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextfield.text else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullName, companyName: "", profileImage: #imageLiteral(resourceName: "profile_placeholder"), isAssetManager: assetManagerSwitch.isOn)
        
        if self.assetManagerSwitch.isOn {
            var isAssetManager = assetManagerSwitch.isOn
            if self.assetManagerSwitch.isOn {
                isAssetManager = true
            }
            
            self.values = ["fullname": fullName,
                           "email": email,
                           "profileImage": "",
                           "companyName": "",
                           "isAssetManager":isAssetManager] as [String: AnyObject]
            
            let controller = CompanyInfoController()
            controller.delegate = self
            controller.values = self.values!
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    ProgressHUD.dismiss()
                }
            })
        } else {
            AuthService.shared.registerUser(credentials: credentials) { (error, ref) in
                if let error = error {
                    ProgressHUD.showError("\(error.localizedDescription)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        ProgressHUD.dismiss()
                    }
                }
            }
        }
    }
        
       

    @objc func handleAlreadyHaveAnAccountTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        if textField == emailTextField {
            signUpViewModel.email = textField.text
        } else if textField == passwordTextfield {
            signUpViewModel.password = textField.text
        } else if textField == confirmPasswordTextfield {
            signUpViewModel.confirmPassword = textField.text }
        else {
            signUpViewModel.fullname = textField.text
        }
        updateForm()
    }
}

extension SignUpController: FormViewModel {
    func updateForm() {
        signUpButton.isEnabled = signUpViewModel.shouldEnableButton
        signUpButton.setTitleColor(signUpViewModel.buttonTitleColor, for: .normal)
        signUpButton.backgroundColor = signUpViewModel.buttonBackgroundColor
    }
}

extension SignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTextField {
            fullNameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextfield.becomeFirstResponder()
            textField.resignFirstResponder()
        } else if textField == passwordTextfield {
            textField.resignFirstResponder()
            confirmPasswordTextfield.becomeFirstResponder()
            passwordTextfield.resignFirstResponder()
        } else if textField == confirmPasswordTextfield {
            textField.resignFirstResponder()
            signUpButton.becomeFirstResponder()
            confirmPasswordTextfield.resignFirstResponder()
        }
        return true
    }
}
extension SignUpController: CompanyInfoControllerDelegate {
    func companyDidSpecified() {
        self.navigationController?.popViewController(animated: false)
        delegate?.registrationComplete()
    }
    
    
}
