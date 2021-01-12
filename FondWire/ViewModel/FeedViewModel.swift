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
    
    var media: String? {
        guard let media = feed.media else { return nil }
        return media
    }

    
    var timeAndDate: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = " h:mm a · MM/dd/yyyy"
        return formatter.string(from: feed.issueDate)
    }
    
    var assetName: String {
        guard let name = feed.name else { return ""}
        return name.uppercased()
    }
    

    
    var bodyTxt: NSAttributedString? {
        var bodyText = NSAttributedString()
        if let text = feed.attrBody {
            bodyText = text
        } else if let teaser = feed.attrTeaser {
            bodyText = teaser
        }
        return bodyText

    }
    
    var detailBodyText: String? {
        
        if let body = feed.bodyText {
            if let teaser = feed.teaser {
                if !body.isEmpty && !teaser.isEmpty {
                    return "\(body) /n \(teaser)"
                } else if !body.isEmpty && teaser.isEmpty {
                    return body
                }
            }
        }
        return feed.teaser
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = feed.title
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
    }
    
    func sizeForDetail(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = detailBodyText
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
    }
}
