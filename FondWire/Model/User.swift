//
//  User.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/31/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct User {
    var fullname: String
    let email: String
    var username: String
    var profileImageUrl: URL?
    let uid: String
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid}
    var stats: UserRelationStats?
    let bio: String
    let companyName: String
    let isAssetManager: Bool

    
    init(uid: String, dictionary: [String: AnyObject]) {
        
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.bio = dictionary["email"] as? String ?? ""
        self.companyName = dictionary["companyName"] as? String ?? ""
        self.isAssetManager = dictionary["isAssetManager"] as? Bool ?? false

        
        if let imgStr = dictionary["profileImageURL"] as? String {
            guard let imgURL = URL(string:imgStr) else { return }
            profileImageUrl = imgURL
        }
    }
    
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
