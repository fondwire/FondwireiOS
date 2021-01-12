//
//  UserService.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/31/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
     static let shared =  UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void)  {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDict = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: userDict)
            completion(user)


        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dict = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dict)
            if let currentUser = Auth.auth().currentUser {
                if currentUser.uid == user.uid {
                    
                } else {
                    users.append(user)
                }
            } else {
                users.append(user)
            }
            completion(users)
        }
    }
    
    func saveProfileImage(image: UIImage, completion: @escaping(URL?) -> Void)  {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let filename = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                let values = ["profileImageURL": profileImageUrl]
                
                REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                    completion(url)
                }
            }
        }
    }
    
    func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["fullname": user.fullname,
                      "email": user.email,
                      "profileImageURL": user.profileImageUrl as Any,
                      "companyName": user.companyName] 
        
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
}


