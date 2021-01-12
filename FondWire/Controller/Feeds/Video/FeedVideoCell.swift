//
//  FeedVideoView.swift
//  FondWire
//
//  Created by Edil Ashimov on 12/10/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit
import WebKit

class FeedVideoCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var assetNameLabel: UILabel!
    @IBOutlet var timeStampLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var archiveButton: UIButton!
    private var mergedStack: UIStackView!
    private var imageLabelStack: UIStackView!
    var mediaURLString: String?

    @IBOutlet weak var spinner: UIActivityIndicatorView!
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
        assetNameLabel.text = feedViewModel.assetName
       
        if let logoURL = feed.logo {
            profileImage.sd_setImage(with: logoURL)
        } else {
            profileImage.image = #imageLiteral(resourceName: "punica")
        }
        
        guard let media = feedViewModel.media,
              let youtbID = media.youtubeID
        else {
            // TO DO: ERROR LOADING A VIDEO LABEL IN WEBVIEW
            return
        }
        webView.navigationDelegate = self
        spinner.isHidden = false
        mediaURLString = media
        loadYoutube(videoID: youtbID)
    }
    
    private func loadYoutube(videoID:String) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return }
        self.webView.load(URLRequest(url: youtubeURL))
    }
    
    @IBAction func archiveTappedd(_ button: UIButton) {
    
        UIView.animate(withDuration: 0.15) {
            self.archiveButton.transform = CGAffineTransform(scaleX: 2, y: 2)
            if self.archiveButton.isSelected {
                self.archiveButton.isSelected = true
                self.archiveButton.tintColor = .lightGray
            } else {
                self.archiveButton.isSelected = false
                self.archiveButton.tintColor = .systemYellow
            }
            self.archiveButton.isSelected = !self.archiveButton.isSelected
            
        } completion: { (_) in
            self.archiveButton.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //TO DO: implement Archive action
        }
    }
}

extension FeedVideoCell: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.isHidden = true
    }
}
