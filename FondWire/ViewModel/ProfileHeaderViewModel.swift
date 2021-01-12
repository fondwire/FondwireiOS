//
//  ProfileHeaderViewModel.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/21/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

enum ProfileCellActions: Int, CaseIterable {
    case me
    case notification
    case legal
    case help
    case logout
    
    var title: String {
        switch self {
        case .me: return "Me"
        case .notification: return "Notification"
        case .legal: return "Legal"
        case .help: return "Help"
        case .logout: return "Logout"
        }
    }

    var icon: UIImage {
        switch self {
        case .me: return #imageLiteral(resourceName: "pen_icon")
        case .notification: return #imageLiteral(resourceName: "notification_icon")
        case .legal: return #imageLiteral(resourceName: "legal_icon")
        case .help: return #imageLiteral(resourceName: "help_icon")
        case .logout: return #imageLiteral(resourceName: "legal_icon")
        }
    }
}


enum ProfileCurrentUser: Int, CaseIterable {
    case following
    case followers

    var title: String {
        switch self {
        case .following: return "FOLLOWING"
        case .followers: return "FOLLOWERS"
            
        }
    }
}

enum ProfileUser: Int, CaseIterable {
    case follow
    case message

    var title: String {
        switch self {
        case .follow: return "FOLLOW"
        case .message: return "MESSAGE"
            
        }
    }
}

enum ProfileFilterOptions: Int, CaseIterable {
    case activity
    case settings

    
    var description: String {
        switch self {
        case .activity: return "ACTIVITY"
        case .settings: return "SETTINGS"
        }
    }
}

struct ProfileHeaderViewModel {
    
    // MARK: - Properties
    private let user: User
//    private let asset: Asset

    var fullName: String {
        return user.fullname
    }
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
    }
    
//    init(asset: Asset) {
//        self.asset = asset
//    }
    
}
