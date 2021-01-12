//
//  FeedsCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/17/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//
//
//import Foundation
//import UIKit
//import WebKit
//import MediaPlayer

//class FeedCollectionViewCell: UICollectionViewCell {
//
//    //MARK: - Properties
//    @IBOutlet var feedView: FeedVideoView!
//    @IBOutlet var feedEventView: FeedEventView!
//}
//
//    var webView = WKWebView()
//
//    private var mergedStack: UIStackView!
////  private var imageLabelStack: UIStackView!
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 3
//        let style = NSMutableParagraphStyle()
//        style.lineSpacing = 5
//        style.alignment = .left
//        style.lineBreakMode = .byWordWrapping
//        let attributes = [NSAttributedString.Key.paragraphStyle : style,
//                          NSAttributedString.Key.font: UIFont.gothamMedium(ofSize: 16),
//                          NSAttributedString.Key.foregroundColor: UIColor.black]
//
//        label.attributedText = NSAttributedString(string: FEED_SAMPLE_TITLE, attributes:attributes)
//        return label
//    }()
//
//    private lazy var profileImage: UIImageView = {
//        let imgView = UIImageView()
//        imgView.clipsToBounds = true
//        imgView.setDimensions(width: 25, height: 25)
//        imgView.layer.cornerRadius = 25/5
//        imgView.image = #imageLiteral(resourceName: "logo7")
//        return imgView
//    }()
//
//
//
//    private let assetNameLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.font = .gothamBook(ofSize: 10)
//        lbl.numberOfLines = 0
//        lbl.textColor = .black
//        lbl.textAlignment = .left
//        return lbl
//       }()
//
//    private let timeStampLabel: UILabel = {
//        let label = UILabel()
//        label.font = .gothamLight(ofSize: 8)
//        label.numberOfLines = 0
//        label.textColor = .darkGray
//        label.textAlignment = .left
//        return label
//    }()
//
//    private let lineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .darkGray
//        view.alpha = 0.5
//        return view
//    }()
//
//    private let playerView: UIView = {
//
//        let view = UIView()
//        view.backgroundColor = .black
//        view.isUserInteractionEnabled = false
//        return view
//    }()
//
//    private let archiveButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("ARCHIVE", for: .normal)
//        button.titleLabel?.font = .gothamBold(ofSize: 10)
//        button.setTitleColor(.darkGray, for: .normal)
//        button.addTarget(self, action: #selector(handleArchiveTapped), for: .touchUpInside)
//        button.contentHorizontalAlignment = .right
//        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
//        button.tintColor = .darkGray
//        button.imageView?.contentMode = .scaleAspectFit
//        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 5, right: -3)
//
//        return button
//    }()
//
//    private var labelStack = UIStackView()
//
//    private let feedTextView: UITextView = {
//        let textView = UITextView()
//        textView.isEditable = false
//        textView.isScrollEnabled = false
//        textView.isUserInteractionEnabled = false
//        textView.backgroundColor = .clear
//
//        let style = NSMutableParagraphStyle()
//        style.lineSpacing = 5
//        style.alignment = .left
//        style.lineBreakMode = .byWordWrapping
//
//
//        let attributes = [NSAttributedString.Key.paragraphStyle : style,
//                          NSAttributedString.Key.font: UIFont.gothamLight(ofSize: 12),
////                          NSAttributedString.Key.foregroundColor: UIColor.black,
//                          NSAttributedString.Key.strokeColor: UIColor.black]
//
//        textView.attributedText = NSMutableAttributedString(string: FEED_SAMPLE_DESCRIPTION, attributes: attributes)
//
//        return textView
//    }()
//
//
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        guard let feed = feed else { return }
//        switch feed.type {
//        case .article:
//            playerView.removeFromSuperview()
//            feedTextView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 10)
//            feedTextView.setDimensions(height: 50, width: frame.width*0.95)
//        case .video:
//            feedTextView.anchor(top: playerView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 10)
//            feedTextView.setDimensions(height: 50, width: frame.width*0.95)
//
//            playerView.setDimensions(height: 150, width: frame.width*0.95)
//            playerView.addSubview(webView)
//            webView.addConstraintsToFillView(playerView)
//        case .podcast:
//            print("")
//        case .event:
//            feedTextView.setDimensions(height: 50, width: frame.width*0.9)
//        }
//
//        archiveButton.setDimensions(height: 20, width: frame.width*0.9)
//        lineView.frame = CGRect(x: profileImage.frame.width, y: imageLabelStack.frame.height+5, width: frame.width*0.95-profileImage.frame.width, height: 0.20)
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        webView.navigationDelegate = self
//
//        backgroundColor = .fwFeedCell
//        let nameAndDateStack = UIStackView(arrangedSubviews: [timeStampLabel])
//        nameAndDateStack.axis = .horizontal
//        nameAndDateStack.distribution = .fill
//
//
//        labelStack = UIStackView(arrangedSubviews: [assetNameLabel, nameAndDateStack])
//        labelStack.axis = .vertical
//        labelStack.spacing = 5
//        labelStack.alignment = .leading
//
//
//        imageLabelStack = UIStackView(arrangedSubviews: [profileImage, labelStack])
//        imageLabelStack.axis = .horizontal
//        imageLabelStack.spacing = 7
//        imageLabelStack.distribution = .fill
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onAssetProfileIconTapped))
//        imageLabelStack.addGestureRecognizer(tapGesture)
//        imageLabelStack.addSubview(lineView)
//
//        addSubview(imageLabelStack)
//        imageLabelStack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15)
//
//        addSubview(titleLabel)
//        titleLabel.anchor(top: imageLabelStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 5)
//
//        addSubview(playerView)
//        playerView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 0, paddingRight: 0)
//
//        addSubview(feedTextView)
//
//        addSubview(archiveButton)
//        archiveButton.anchor(top: feedTextView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingRight: 15)
//
//
//    }
//
//
//     func loadYoutube(videoID:String) {
//        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return }
//            self.webView.load(URLRequest(url: youtubeURL))
//    }
//
//
//    func configure()  {
//        guard let feed = feed else { return }
//        let feedViewModel = FeedViewModel(feed: feed)
//        titleLabel.text = feedViewModel.title
//        timeStampLabel.text = feedViewModel.timeAndDate
//        feedTextView.attributedText = feedViewModel.bodyTxt
//        assetNameLabel.text = feedViewModel.assetName
//        profileImage.image = feedViewModel.logo
//
//        if feed.type == .video {
//        if let media = feedViewModel.media {
//
//                let activityIndicator = UIActivityIndicatorView()
//                activityIndicator.style = .gray
//                activityIndicator.frame.size.width = 50
//                activityIndicator.frame.size.height = 50
//                activityIndicator.frame = self.bounds
//
//                let youtubeID = media.youtubeID
//                guard let youtbID = youtubeID else { return }
//                addSubview(activityIndicator)
//                activityIndicator.startAnimating()
//
//                self.loadYoutube(videoID: youtbID)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//
//                    activityIndicator.stopAnimating()
//                    activityIndicator.removeFromSuperview()
//            }
//
//        }
//
//        } else {
//            playerView.removeFromSuperview()
//        }
//    }
//
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//      for i in (0..<subviews.count-1).reversed() {
//        let newPoint = subviews[i].convert(point, from: self)
//        if let view = subviews[i].hitTest(newPoint, with: event) {
//            return view
//        }
//      }
//      return super.hitTest(point, with: event)
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//
//    }
//
//    //MARK: - Helpers
//
//    //MARK: - Selectors
//
//    @objc func onAssetProfileIconTapped() {}
//
//
//    @objc func handleArchiveTapped() {
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//    }
//}
//
//extension FeedCollectionViewCell: WKNavigationDelegate {
//
//
//}


