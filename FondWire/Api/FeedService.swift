//
//  FeedService.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/31/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct FeedService {
    
    static let shared =  FeedService()
    
    func uploadFeed(title: String, type: FeedType, completion: @escaping(Error?, DatabaseReference) -> Void) {

        var values = ["uid": "MPDM0e5yBnbMFap2PJyiSpK2Qw22",
                      "issueDate": Int(NSDate().timeIntervalSince1970),
                      "media": "",
                      "name": "",
                      "logo": "",
                      "teaser": "",
                      "bodyText": "",
                      "link": "",
                      "category": "",
                      "type": type.rawValue,
                      "url": "",
                      "title": title] as [String : Any]
        
        switch type {
        case .article:
            REF_FEEDS_ARTICLE.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        case .video:
            REF_FEEDS_VIDEO.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        case .podcast:
            REF_FEEDS_PODCAST.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        case .event:
            REF_FEEDS_EVENT.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
            values["eventDate"] = ""
        }
    }
    
    func fetchFeeds(completion: @escaping([Feed]) -> Void) {
        var feeds = [Feed]()


    }
    
    func fetchFeed( completion: @escaping([Feed]) -> Void) {
        var feeds = [Feed]()
        
        REF_FEEDS.observeSingleEvent(of: .value) { (snapshot) in
            guard let snap = snapshot.value as? [String: Any] else { return }
            var dict = [String: Any]()
            for (_, value) in snap {
                dict = value as! [String : Any]
                for (key, _) in dict {
                    let feed = dict[key] as! [String : Any]
                    
                    UserService.shared.fetchUser(uid: feed["uid"] as! String) { (user) in
                        var feed = Feed(user: user, dict: feed)
                        if let bodyText = feed.bodyText {
                            if !bodyText.isEmpty {
                                feed.attrBody = getTextFromHTML(text: bodyText)
                            }
                        if let teaser = feed.teaser {
                            if !teaser.isEmpty {
                                feed.attrTeaser = getTextFromHTML(text: teaser)
                            }
                            
                        }
                            if let assetName = feed.name {
                                if let imageURLString = getAssetIconURLString(assetName: assetName) {
                                    feed.logo = URL(string: imageURLString)
                                }
                            }
                            if feed.isAdminApproved && feed.isAssetManagerApproved {
                                feeds.append(feed)
                            }
                            completion(feeds)
                        }
                    }
                }
            }
        }
    }
    
    func getAssetIconURLString(assetName name: String) -> String? {
            
    
        for asset in DataService.shared.assets {
            if asset.name.lowercased() == name.lowercased() {
                if let url = asset.profileImageURL {
                    return url
                }
            }
        }
        return nil
    }
    
    func getTextFromHTML(text: String) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.alignment = .left
        style.lineBreakMode = .byWordWrapping
        
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          NSAttributedString.Key.font: UIFont.gothamBook(ofSize: 10),
                          NSAttributedString.Key.foregroundColor: UIColor.black]
        var attrText = NSMutableAttributedString()
        let data = Data(text.utf8)
        if let attrStr = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            attrText = attrStr
            attrText.addAttributes(attributes, range: NSRange(location: 0, length: attrText.length))
        }
        return attrText
    }
}
