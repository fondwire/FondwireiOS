//
//  FeedViewModel.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/25/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit
import SDWebImage

struct FeedViewModel {
    let feed: Feed
    
    init(feed: Feed) {
           self.feed = feed
    }
    
    var title: String {
          return feed.title
    }
    
    var link: String? {
        guard let link = feed.link else { return nil }
        return link
    }

    
    var timeAndDate: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = " h:mm a · MM/dd/yyyy"
        return formatter.string(from: feed.issueDate)
    }
    
    var assetName: String {
        guard let name = feed.name else { return "This is the title placeholder" }
        return name.uppercased()
    }
    

    
    var bodyTxt: NSAttributedString? {
        var bodyText = NSAttributedString()
        
        if let text = feed.attrBody {
            if !text.string.isEmpty {
                bodyText = text
            } else {
                if let teaser = feed.attrTeaser {
                    if !teaser.string.isEmpty {
                        bodyText = teaser
                    }
                }
            }
        } else if let teaser = feed.attrTeaser {
            if !teaser.string.isEmpty {
                bodyText = teaser
            }
        }
        return bodyText

    }
    var detailBodyText: NSAttributedString? {
        return bodyTxt
    }
    
    func size(forWidth width: CGFloat, withbodyText bodyText: NSMutableAttributedString, andTitle title: String, forFeedType feedType: FeedType) -> CGSize {
        let approximateWidthOfContent = width
        // x is the width of the logo in the left
        let size = CGSize(width: approximateWidthOfContent, height: 1000)
        //1000 is the large arbitrary values which should be taken in case of very high amount of content
        
        let attributes = [NSAttributedString.Key.font: UIFont.gothamLight(ofSize: 12)]
        var estimatedBodyTextFrame: CGRect?
        var estimatedTitleTextFrame: CGRect?
        var additionalElementsHeights: CGFloat = 0
        
        switch feedType {
        case .article:
            ()
        case .video:
            ()
        case .podcast:
            ()
        case .event:
            additionalElementsHeights = Device.isPhone ? 250 : 150
        }
        
        return CGSize(width: width, height: additionalElementsHeights)
            
    }
    
    func sizeForDetail(forWidth width: CGFloat, for text: String) -> CGSize {
        
        let approximateWidthOfContent = width
        // x is the width of the logo in the left
        let size = CGSize(width: approximateWidthOfContent, height: 1000)
        //1000 is the large arbitrary values which should be taken in case of very high amount of content
        
        let attributes = [NSAttributedString.Key.font: UIFont.gothamLight(ofSize: 12)]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return CGSize(width: width, height: estimatedFrame.height)
    }
}
