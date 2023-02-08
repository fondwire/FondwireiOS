//
//  FeedEventCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 12/10/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit

protocol EventCellDelegate: AnyObject {
    func dismissTapped(for cell: FeedEventCell)
}

class FeedEventCell: UICollectionViewCell {
    weak var delegate: EventCellDelegate?
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var learnMoreButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet weak var eventBannerImageView: UIImageView!
    var indexPath: IndexPath?
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    var feed: Feed! {
        didSet {
            self.configure()
        }
    }
    
    func configure()  {
        guard let feed = feed else { return }
        let feedViewModel = FeedViewModel(feed: feed)
        dateLabel.text = feedViewModel.timeAndDate
        titleLabel.text = feedViewModel.title
        textView.attributedText = feedViewModel.bodyTxt
        learnMoreButton.layer.cornerRadius = 10
        
        if let mediaFileURLString = feed.media {
            if let mediaFileURL = URL(string: mediaFileURLString) {
                eventBannerImageView.isHidden = false
                eventBannerImageView.sd_setImage(with: mediaFileURL)
                
            }
        }
        
        if let logoURL = feed.logo {
            profileImageView.sd_setImage(with: logoURL)
        } else {
            profileImageView.image = #imageLiteral(resourceName: "punica")
        }
        
        
    }
    
    @objc func handleInterestedTapped() {
    }

    @IBAction func dismissTapped(_ button: UIButton) {
        Vibration.rigid.vibrate()
            UIView.animate(withDuration: 0.15) {
                button.transform = CGAffineTransform(scaleX: 2, y: 2)
            } completion: { (_) in
                button.transform = .identity
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let currentCell = self
            self.delegate?.dismissTapped(for: currentCell)
        }
    }
}
