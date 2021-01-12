//
//  Feed.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/25/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

enum FeedType: String {
    case article = "article"
    case video = "video"
    case podcast = "podcast"
    case event = "event"
}

struct Feed {
    var title: String
    var media: String?
    var issueDate: Date!
    var eventDate: Date?
    var name: String?
    var logo: URL?
    var teaser: String?
    var bodyText: String?
    var url: String?
    var category: String?
    var uid: String
    var type: FeedType
    var attrBody: NSAttributedString?
    var attrTeaser: NSAttributedString?
    var user: User
    let isAssetManagerApproved: Bool
    let isAdminApproved: Bool
    
    init(user: User, dict: [String: Any]) {
        
        self.uid = user.uid
        self.title = dict["title"] as? String ?? ""
        self.media = dict["media"] as? String ?? ""
        self.issueDate = dict["issueDate"] as? Date
        self.eventDate = dict["eventDate"] as? Date
        self.name = dict["name"] as?  String
        self.logo = dict["logo"] as? URL
        self.teaser = dict["teaser"] as? String
        self.url = dict["url"] as? String ?? ""
        self.uid = dict["uid"] as? String ?? ""
        self.type = FeedType(rawValue: dict["type"] as! FeedType.RawValue)!
        self.user = user
        self.category = dict["category"] as? String ?? ""
        self.bodyText = dict["bodyText"] as? String
        self.isAdminApproved = dict["isAdminApproved"] as? Bool ?? false
        self.isAssetManagerApproved = dict["isAssetManagerApproved"] as? Bool ?? false


        
        

        if let timeStamp = dict["issueDate"] as? Double {
            self.issueDate = Date(timeIntervalSince1970: timeStamp)
        }
    }
}
