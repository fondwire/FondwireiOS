//
//  FeedEventCollectionViewCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/29/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class FeedEventCollectionViewCell: UICollectionViewCell {
   
    var feed: Feed? {
             didSet {
                 self.configure()
             }
         }
    
    private lazy var profileImage: UIImageView = {
          let imgView = UIImageView()
          imgView.clipsToBounds = true
          imgView.setDimensions(width: 70, height: 70)
          imgView.layer.cornerRadius = 70/2
          imgView.image = #imageLiteral(resourceName: "logo7")
          return imgView
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
    
    private let titleLabel: UILabel = {
         let label = UILabel()
         label.numberOfLines = 2
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
    
    private let feedTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled  = false
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.alignment = .left
        style.lineBreakMode = .byWordWrapping

        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          NSAttributedString.Key.font: UIFont.gothamLight(ofSize: 12),
                          NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1)]
        
        textView.attributedText = NSAttributedString(string: FEED_SAMPLE_DESCRIPTION, attributes:attributes)
        return textView
    }()
    
    
    private let interestedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("INTERESTED", for: .normal)
        button.titleLabel?.font = .gothamBold(ofSize: 10)
        button.setTitleColor(.fwGreen, for: .normal)
        button.addTarget(self, action: #selector(handleInterestedTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.tintColor = .fwGreen
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 12, bottom: 5, right: 0)
        button.contentHorizontalAlignment = .trailing
        return button
     }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CLOSE", for: .normal)
        button.titleLabel?.font = .gothamBold(ofSize: 10)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .gray
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 5, right: 12)
        button.contentHorizontalAlignment = .trailing
        return button
        }()
    
    private let eventLabel: UILabel = {
        let label = UILabel()
        label.text = "EVENT INVITATION"
        label.font = .gothamBold(ofSize: 12)
        label.textColor = .fwCyan
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = .fwDarkBlueFg
        addSubview(eventLabel)
        eventLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15)
        
        let nameAndDateStack = UIStackView(arrangedSubviews: [timeStampLabel])
        nameAndDateStack.axis = .horizontal
        nameAndDateStack.alignment = .center
        addSubview(nameAndDateStack)
        nameAndDateStack.anchor(top: eventLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingRight: 15)
        nameAndDateStack.setDimensions(height: 10, width: frame.width/2)
        nameAndDateStack.distribution = .equalCentering
        nameAndDateStack.alignment = .center
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nameAndDateStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15)

        
        let bodyStack = UIStackView(arrangedSubviews: [profileImage, feedTextView])
        bodyStack.axis = .horizontal
        bodyStack.spacing = 10
        addSubview(bodyStack)
        bodyStack.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15)
        
        let actionStack = UIStackView(arrangedSubviews: [interestedButton, dismissButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 20
        addSubview(actionStack)
        actionStack.anchor(top: bodyStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        feedTextView.setDimensions(height: 70, width: frame.width*0.9)
    }
    
    func configure()  {
        guard let feed = feed else { return }
        let feedViewModel = FeedViewModel(feed: feed)
        timeStampLabel.text = feedViewModel.timeAndDate
        titleLabel.text = feedViewModel.title
        feedTextView.attributedText = feedViewModel.bodyTxt
        profileImage.image = feedViewModel.logo

       }
    
    @objc func handleInterestedTapped() {
    }
    
    @objc func handleDismissTapped() {
    }
}
