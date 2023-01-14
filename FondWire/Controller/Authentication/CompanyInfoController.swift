//
//  CompanyInfoController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/12/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol CompanyInfoControllerDelegate: class {
    func companyDidSpecified()
}


class CompanyInfoController: UIViewController {
    
    //MARK: -  Properties
    weak var delegate: CompanyInfoControllerDelegate?
    var textField =  UITextField()
    var tableView = UITableView()
    var selectedIndexPath: IndexPath?
    private var viewModel = CompanyInfoViewModel()
    var values:[String: AnyObject]?

    private let iconStackView: UIStackView = {
        let almostDoneLabel = UILabel()
        almostDoneLabel.text = "Almost done"
        almostDoneLabel.font = UIFont.gothamMedium(ofSize: 20)
        almostDoneLabel.numberOfLines = 1
        almostDoneLabel.textColor = UIColor(white: 1, alpha: 0.7)
        let iconImage = UIImageView(image: #imageLiteral(resourceName: "fondwireLogo"))
        
        let stackView = UIStackView(arrangedSubviews: [almostDoneLabel, iconImage])
        iconImage.setDimensions(height: 80, width: 80)
        iconImage.centerX(inView: stackView)
        stackView.axis = .vertical
        stackView.setCustomSpacing(20, after: almostDoneLabel)
        stackView.alignment = .center
        return stackView
    }()
    
    private let companyNameTextField = CustomTextField(withPlaceholder: "Company Name")
   
    private let companyTypeTextField: UITextField = {
        let textfield = CustomTextField(withPlaceholder: "Select or type Company")
        let arrowButton = UIButton(type: .system)
        textfield.addSubview(arrowButton)
        arrowButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        arrowButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        arrowButton.setDimensions(height: 10, width: 20)
        arrowButton.imageView!.contentMode = .scaleAspectFit
        arrowButton.tintColor = UIColor(white: 1, alpha: 0.7)
        arrowButton.addTarget(self, action: #selector(handleArrowButtonTapped), for: .touchUpInside)
        textfield.rightView = arrowButton
        textfield.rightViewMode = .always
        return textfield
    }()

    private let finishButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.title = "Finish"
        button.addTarget(self, action: #selector(handleFinishButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .gothamMedium(ofSize: 14)
        return button
    }()

    
    // The sample values
    var typeValues = ["Type 1", "Type 2", "Type 3", "Type 4"]
    let cellReuseIdentifier = "dropDownCell"
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        companyNameTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        companyNameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationItem.hidesBackButton = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
           // Assumption is we're supporting a small maximum number of entries
           // so will set height constraint to content size
           // Alternatively can set to another size, such as using row heights and setting frame
        tableView.setDimensions(height: tableView.contentSize.height, width: tableView.frame.width)
    }

    //MARK: - Helpers
    func configureUI() {
        companyTypeTextField.delegate = self
        companyNameTextField.delegate = self
        self.view.backgroundColor = .fwDarkBlueBg
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black

        view.addSubview(iconStackView)
        iconStackView.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 60, width: 200)
        iconStackView.centerX(inView: view)
        
        let stackView = UIStackView(arrangedSubviews: [companyNameTextField, companyTypeTextField])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.anchor(top: iconStackView.bottomAnchor, paddingTop: 40)
        stackView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        stackView.centerX(inView: view)
        
        view.addSubview(finishButton)
        finishButton.anchor(top: stackView.bottomAnchor, paddingTop: 20)
        finishButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
       
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.backgroundColor = .fwDarkBlueBg
        tableView.allowsMultipleSelection = false
        view.addSubview(tableView)
        tableView.anchor(top: stackView.bottomAnchor, paddingTop: 10)
        tableView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        tableView.isHidden = true
    }
    
    func configureNotificationObservers()  {
        companyNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        companyTypeTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
      }
    
    // Manage keyboard and tableView visibility
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        guard let touch:UITouch = touches.first else { return }
        if touch.view != tableView {
            textField.endEditing(true)
            tableView.isHidden = true
        }
        if touch.view != companyNameTextField || touch.view != companyTypeTextField {
            view.endEditing(true)
        }
    }
    
    //MARK: - Selectors
    @objc func handleFinishButtonTapped() {
            guard let companyName = companyNameTextField.text,
                  let currentUserUid = Auth.auth().currentUser?.uid,
                  let companyType = companyTypeTextField.text,
                  var values = values else { return }
            
            values["companyName"] = companyName as AnyObject
            
        guard var user = DataService.shared.currentUser else { return }
            self.values = ["fullname": user.fullname,
                           "email": user.email,
                           "profileImage": user.profileImageUrl as Any,
                           "companyName": companyName] as [String: AnyObject]
            user = User(uid: currentUserUid, dictionary: values)
            
            UserService.shared.saveUserData(user: user) { (error, ref) in
                if let _ = error {
                    // IN CASE OF ERROR
                } else {
                    AssetService.shared.fetchAssets { (assets) in
                        
                        //Checking if the company already exists
                        
                        let companyExists = assets.contains { asset in
                            if asset.name == companyName {
                                //  Getting a list of existing managers and adding a new one
                                var managersDict = asset.managers?["managers"] as! [String: Any]
                                managersDict.merge(dict: [DataService.shared.currentUser!.fullname: currentUserUid])
                                //Adding a new manager to an existing company
                                AssetService.shared.addNewManager(companyName: companyName, managers: managersDict) { (error, ref) in
                                    
                                    //once it is added dissming and callin the delegate
                                    self.dismiss(animated: true) {
                                        self.delegate?.companyDidSpecified()
                                        managersDict.removeAll(keepingCapacity: true)
                                    }
                                }
                                return true
                            }
                            return false
                        }
                        if !companyExists {
                            // Assuming that the the company doesn't exist we are creating a new asset and adding a new manager
                            AssetService.shared.createNewAsset(companyName: companyName, managerUid: DataService.shared.currentUser!.uid, managerName: DataService.shared.currentUser!.fullname, companyType: companyType) { (error, ref) in
                                self.dismiss(animated: true) {
                                    self.delegate?.companyDidSpecified()
                                }
                            }
                            
                        }
                }
            }
        }
    }
  @objc func handleArrowButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.isHidden.toggle()
        }
        view.endEditing(true)
    }
    
    @objc func textDidChange(_ textField: UITextField) {

        if textField == companyNameTextField {
            viewModel.companyName = textField.text
        }
        if textField == companyTypeTextField  {
            viewModel.companyType = textField.text
        }
        
        if textField == companyTypeTextField {
            tableView.isHidden = true
        }
        updateForm()
    }
}

extension CompanyInfoController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == companyNameTextField {
            companyTypeTextField.resignFirstResponder()
            companyTypeTextField.becomeFirstResponder()
        } else if textField == companyTypeTextField {
            companyTypeTextField.resignFirstResponder()
            finishButton.becomeFirstResponder()
            companyTypeTextField.resignFirstResponder()
        }
        return true
    }
    
}

extension CompanyInfoController: FormViewModel {
    func updateForm() {
        finishButton.isEnabled =  viewModel.shouldEnableButton
        finishButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        finishButton.backgroundColor = viewModel.buttonBackgroundColor
    }
}

// MARK: UITableViewDataSource

extension CompanyInfoController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeValues.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        // Set text from the data model
        cell.textLabel?.text = typeValues[indexPath.row]
        cell.textLabel?.font = companyTypeTextField.font
        cell.textLabel?.textColor = UIColor(white: 0.9, alpha: 1)
        cell.backgroundColor = .fwDarkBlueBg
        cell.contentView.backgroundColor = .clear
        return cell
    }

    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex = selectedIndexPath {
            tableView.deselectRow(at: selectedIndex, animated: false)
        }
        
        companyTypeTextField.text = typeValues[indexPath.row]
        viewModel.companyType = typeValues[indexPath.row]
        textDidChange(companyTypeTextField)
        
        tableView.isHidden = true
        companyTypeTextField.endEditing(true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.3, animations: {
                cell.contentView.backgroundColor = UIColor.fwYellow
                cell.contentView.backgroundColor?.withAlphaComponent(0.7)
            })
        }
        selectedIndexPath = indexPath
    }

    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
          if let cell = tableView.cellForRow(at: indexPath) {
                cell.contentView.backgroundColor = UIColor.fwDarkBlueBg
              }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
