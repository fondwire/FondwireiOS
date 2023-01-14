//
//  ArticleView.swift
//  FondWire
//
//  Created by Edil Ashimov on 12/30/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet var archiveButton: UIButton! {
        didSet {
            archiveButton.setImage(UIImage(named: "bookmark"), for: .normal)
            archiveButton.setImage(UIImage(named: "bookmark-highlighted"), for: .selected)
        }
    }
    var mediaURLString: String?

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.alpha = 0.5
        return view
    }()

    var feed: Feed! {
        didSet {
            self.configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder  ) {
        super.init(coder:  aDecoder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    func configureUI()  {
        archiveButton.tintColor = .darkGray
        archiveButton.imageView?.contentMode = .scaleAspectFit
        archiveButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 5, right: -3)
        profileImage.image = #imageLiteral(resourceName: "launchLogo")
    }
    
    func configure()  {
        guard let feed = feed else { return }
        let feedViewModel = FeedViewModel(feed: feed)
        titleLabel.text = feedViewModel.title
        timeStampLabel.text = feedViewModel.timeAndDate
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.attributedText = feedViewModel.bodyTxt
        textView.isScrollEnabled = false
        assetNameLabel.text = feedViewModel.assetName
       
        if let logoURL = feed.logo {
            profileImage.sd_setImage(with: logoURL)
        } else {
            profileImage.image = #imageLiteral(resourceName: "punica")
        }
    }
    @IBAction func archiveButtonTapped(_ sender: Any) {
        archiveButton.isSelected = !archiveButton.isSelected
        UIView.animate(withDuration: 0.15) {
            Vibration.medium.vibrate()
            self.archiveButton.transform = CGAffineTransform(scaleX: 2, y: 2)
        } completion: { (_) in
            self.archiveButton.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //TO DO: implement Archive action
        }
    }
}
