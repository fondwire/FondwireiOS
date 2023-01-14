//
//  ProfileController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/15/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import ProgressHUD

private let cellReuseID = "profileCell"
private let activityReuseID = "activityCell"
private let profileHeaderReuseID = "profileHeader"


class ProfileController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var selectedFilter: ProfileFilterOptions = .activity {
           didSet { collectionView.reloadData() }
       }
    
     private let imagePicker = UIImagePickerController()
    
     private var selectedImage: UIImage? {
         didSet {
             header.profileImgVw.image = selectedImage
         }
     }
    private var userInfoChanged = false
    private var imageChanged = false
    
    private let backButton: UIButton = {
          let button = UIButton(type: .system)
          button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
          button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
          button.tintColor = .white
          return button
      }()

    var header = ProfileHeader()

     var user: User? {
        didSet {
            header.user = user
        }
    }
    


    //MARK: - Lifecycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.preferredContentSize = CGSize(width: 100, height: 100)

    }
    
    override func viewDidLoad() {
        super .viewDidLoad()

        
        configureUI()
        configureImagePicker()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "userUpdatedFromFeed"), object: nil)
        
            if user == nil {
                fetchUser()
            } else {
                if let user = user {
                    header.user = user
                }
            }
    }
    
    
    @objc func loadList(){
        //load data here
        print("DEBUG: USER FETCHED")
        fetchUser()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        collectionView.backgroundColor = .white

            // Fallback on earlier versions
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        collectionView.frame.origin.y -= (window.windowScene?.statusBarManager?.statusBarFrame.height)! as CGFloat
        
        navigationItem.title = "PROFILE"
        collectionView.register(ProfileActivityCell.self, forCellWithReuseIdentifier: activityReuseID)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseID)


        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: profileHeaderReuseID)
        collectionView.delegate = self
        collectionView.dataSource = self        
        
        if let user = user {
            if !isUserCurrent(user: user) {
                view.addSubview(backButton)
                backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingLeft: 16)
            }
        }

    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { (user)  in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func updateProfilePhoto() {
        guard let image = selectedImage else {
            ProgressHUD.showError("No image Selected")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                ProgressHUD.dismiss()
            }
           return
            
        }

        
        UserService.shared.saveProfileImage(image: image) { (profileImageURL) in
            ProgressHUD.showSuccess("Avatar Updated")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                ProgressHUD.dismiss()
            }
        }
        
    }
    
   fileprivate func logOutUsr(handleComplete:(()->()))  {
    ProgressHUD.show("Loging Out")
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                ProgressHUD.showSucceed("Logged Out", interaction: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    ProgressHUD.dismiss()
                }
            }
            user = nil
            DataService.shared.currentUser = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userUpdatedFromProfile"), object: nil)
            handleComplete()
        } catch {
            ProgressHUD.showError("\(error.localizedDescription)", image: nil, interaction: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                 ProgressHUD.dismiss()
             }
        }
    }

    @objc func handleDismissal() {
         navigationController?.popViewController(animated: true)
     }
    
    func isUserCurrent(user: User) -> Bool {
        
        guard let currentUser = Auth.auth().currentUser else { return false }
        if currentUser.uid == user.uid {
            return true
        } else {
            return false
        }
    }
    
    func handleLogin() {
        let controller = LoginController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //MARK: - Selectors
}

// MARK: UICollectionViewDataSource/Delegate
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedFilter {
        case .activity:
            return 1
        case .settings:
            return ProfileCellActions.allCases.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch selectedFilter {
        case .activity:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityReuseID, for: indexPath) as! ProfileActivityCell
            return cell
        case .settings:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! ProfileCollectionViewCell
            
            let action = ProfileCellActions(rawValue: indexPath.row)
            cell.titleButton.setTitle(action?.title, for: .normal)
            if action?.title == "Logout" {
                cell.titleButton.setTitleColor(.red, for: .normal)
            } else {
                cell.titleButton.setTitleColor(.darkGray, for: .normal)
                cell.titleButton.imageView?.tintColor = .darkGray

            }
            if action?.rawValue == 4 {
                if Auth.auth().currentUser == nil {
                    cell.titleButton.setTitleColor(.fwCyan, for: .normal)
                    cell.titleButton.setTitle("Login", for: .normal)
                } else {
                    cell.titleButton.setTitleColor(.red, for: .normal)
                    cell.titleButton.setTitle("Logout", for: .normal)

                }
            } 
            cell.titleButton.setImage(action?.icon, for: .normal)
            
            return cell
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch selectedFilter {

        case .activity:
            print("")
        case .settings:
            let action = ProfileCellActions(rawValue: indexPath.row)
            
            switch action {
            case .help:
                comingSoon()
            case .me:
                comingSoon()
            case .notification:
                comingSoon()
            case .legal:
                comingSoon()
            case .logout:
                if Auth.auth().currentUser != nil {
                    logOutUsr {
                        collectionView.reloadItems(at: [indexPath])
                    }
                } else {
                    handleLogin()
                    collectionView.reloadItems(at: [indexPath])
                }
            case .none:
                print("")
            }
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch selectedFilter {
        case .activity:
            return CGSize(width: view.frame.width, height: 100)
        case .settings:
            return CGSize(width: view.frame.width, height: 60)
        }
    }
}

// MARK: UICollectionViewHeaderDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileHeaderReuseID, for: indexPath) as! ProfileHeader
//        header.user = user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height*0.40)

    }
}

extension ProfileController: ProfileHeaderDelegate {
    func didTapProfileChangePhoto() {
        
        let alertController = UIAlertController(title: "Update Profile Photo", message: "Would you like to Update your profile Photo?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { (showPicker) in
            self.present(self.imagePicker, animated:  true)
        }))
        
        present(alertController, animated: true)

    }
    
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImage = image
        imageChanged = true
        dismiss(animated: true) {
            self.updateProfilePhoto()
        }
    }
}

extension ProfileController: LoginControllerDelegate {
    func loginCompleted() {        
        fetchUser()
        collectionView.reloadData()
        ProgressHUD.showSucceed("Logged In", interaction: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            ProgressHUD.dismiss()
        }
        
    }
}
