//
//  FeedDetailCollectionViewCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/30/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class FeedDetailCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var feed: Feed? {
           didSet {
               self.configure()
           }
       }
    
    var webView = WKWebView()

    private var mergedStack: UIStackView!
    private var imageLabelStack: UIStackView!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.alignment = .left
        style.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          NSAttributedString.Key.font: UIFont.gothamMedium(ofSize: 16),
                          NSAttributedString.Key.foregroundColor: UIColor.black]
        
        label.attributedText = NSAttributedString(string: FEED_SAMPLE_TITLE, attributes:attributes)
        return label
    }()
    
    private lazy var profileImage: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.setDimensions(width: 25, height: 25)
        imgView.layer.cornerRadius = 25/2
        imgView.image = #imageLiteral(resourceName: "logo7")
        return imgView
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.alpha = 0.5
        return view
    }()
    
    private let assetNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .gothamBook(ofSize: 10)
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.text = "Vanguard 500 Idx; Adm"
        lbl.textAlignment = .left
        return lbl
       }()
       
    
    private let timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = .gothamLight(ofSize: 8)
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.text = "12/12/12"
        label.textAlignment = .left
        return label
    }()
    
    
    private let mediaView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    
    private let feedTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.alignment = .left
        style.lineBreakMode = .byWordWrapping

        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          NSAttributedString.Key.font: UIFont.gothamLight(ofSize: 14),
                          NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1)]
        
        textView.attributedText = NSAttributedString(string: FEED_SAMPLE_DESCRIPTION, attributes:attributes)
        return textView
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        backgroundColor = .white

        let nameAndDateStack = UIStackView(arrangedSubviews: [timeStampLabel])
        nameAndDateStack.axis = .horizontal
        nameAndDateStack.distribution = .fill
        
        let labelStack = UIStackView(arrangedSubviews: [assetNameLabel, nameAndDateStack])
        labelStack.axis = .vertical
        labelStack.spacing = 5
        labelStack.alignment = .leading
        //        labelStack.distribution = .fill
        
        imageLabelStack = UIStackView(arrangedSubviews: [profileImage, labelStack])
        imageLabelStack.axis = .horizontal
        imageLabelStack.spacing = 7
        imageLabelStack.distribution = .fill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onAssetProfileIconTapped))
        imageLabelStack.addGestureRecognizer(tapGesture)
        
        addSubview(imageLabelStack)
        imageLabelStack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15)
        
        
        addSubview(lineView)
//        lineView.anchor(top:imageLabelStack.bottomAnchor, left: imageLabelStack.rightAnchor, paddingTop: 5, height: 0.20)

        addSubview(titleLabel)
        titleLabel.anchor(top: imageLabelStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingRight: 15)
        
        addSubview(mediaView)
        mediaView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingRight: 15)
        
        addSubview(feedTextView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
                 
         switch feed?.type {
         case .article:
             feedTextView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingRight: 15)
         case .video:
             feedTextView.anchor(top: mediaView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingRight: 15)

             mediaView.setDimensions(height: 150, width: frame.width*0.9)
             mediaView.addSubview(webView)
             webView.addConstraintsToFillView(mediaView)
         case .podcast:
             print("")
         case .event:
             print("EVENT")
         case .none:
             print("")
         }
         feedTextView.setDimensions(height: 1000, width: frame.width*0.9)

        lineView.frame = CGRect(x: profileImage.frame.width, y: imageLabelStack.frame.height*2, width: frame.width*0.95-profileImage.frame.width, height: 0.20)
        super.layoutSubviews()
     }
    
    
    func configure()  {
        
        guard let feed = feed else { return }
         let feedViewModel = FeedViewModel(feed: feed)
         titleLabel.text = feedViewModel.title
         timeStampLabel.text = feedViewModel.timeAndDate
        
     
        feedTextView.setHTMLFromString(htmlText: feedViewModel.detailBodyText!)
        
        
        assetNameLabel.text = feedViewModel.assetName
               
        if let logoURL = feed.logo {
            profileImage.sd_setImage(with: logoURL)
        } else {
            profileImage.image = #imageLiteral(resourceName: "punica")
        }
        

         if let link = feedViewModel.link {
             let youtubeID = link.youtubeID
                guard let youtbID = youtubeID else { return }
             loadYoutube(videoID: youtbID)
         } else {
         }
         
       
                
    }
 
    fileprivate func loadYoutube(videoID:String) {
         guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return }
            webView.load(URLRequest(url: youtubeURL))
     }
    
    @objc func onAssetProfileIconTapped() {
        
    }
    
}

