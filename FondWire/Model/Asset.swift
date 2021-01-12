//
//  Asset.swift
//  FondWire
//
//  Created by Edil Ashimov on 9/26/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Asset {
    var name: String
    let type: String
    let teaser: String?
    let managers: [String : Any]?
    let profileImageURL: String?
    let contactPerson: ContactPerson?
    init(name: String, type: String, teaser: String?, managers: [String : Any]?, profileImageURL: String?, contactPerson: ContactPerson? = nil) {
        self.name = name
        self.type = type
        self.teaser = teaser
        self.managers = managers
        self.profileImageURL = profileImageURL
        self.contactPerson = contactPerson
    }
}

struct ContactPerson {
    let name: String?
    let email: String?
    let phone: String?
    let position: String?
    let profileImageURL: String?

    init(dictionary: [String: AnyObject]){
        self.name = dictionary["name"] as? String ?? "Not Provided"
        self.email = dictionary["email"] as? String ?? "Not Provided"
        self.phone = dictionary["phone"] as? String ?? "Not Provided"
        self.position = dictionary["position"] as? String ?? "Not Provided"
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? "Not Provided"
    }
}
