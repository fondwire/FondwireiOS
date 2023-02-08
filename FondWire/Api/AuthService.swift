//
//  AuthService.swift
//  FondWire
//
//  Created by Edil Ashimov on 8/24/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import ProgressHUD


struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let companyName: String
    let profileImage: UIImage
    let isAssetManager: Bool
}

struct AuthService {
    static let shared = AuthService()
    
    func signUserIn(email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials : AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void)  {
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let companyName = credentials.companyName
        let profileImage = credentials.profileImage
        let isAssetManager = credentials.isAssetManager
        
        var imageData: Data
        
        if profileImage.jpegData(compressionQuality: 0.3) == nil {
            imageData = #imageLiteral(resourceName: "profile_placeholder").jpegData(compressionQuality: 0.3)!
        } else {
            imageData = profileImage.jpegData(compressionQuality: 0.3)!
        }
        
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            
            if let error = error {
                ProgressHUD.showError("\(error.localizedDescription)")
            }
            storageRef.downloadURL { (url, error) in
                guard let profileImgURL = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        ProgressHUD.showError("\(error.localizedDescription)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            ProgressHUD.dismiss()
                        }
                    } else {
                        guard let uid = result?.user.uid else { return }
                        let values = ["email": email,
                                      "companyName" : companyName,
                                      "fullname": fullname,
                                      "profileImageURL": profileImgURL,
                                      "isAssetManager" : isAssetManager] as [String : Any]
                        
                        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                    }
                }
            }
        }
    }
}
