//
//  AssetsCustomCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/16/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit

class AssetsTableCell: UITableViewCell {
    
    static let reuseID = "assetsCell"

    var asset: Asset? {
        didSet {
            configure()
        }
    }
    
    private lazy var assetProfileImgVw: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.backgroundColor = UIColor(white: 1, alpha: 0.7)
        imageView?.contentMode = .scaleAspectFit
        imgView.image = #imageLiteral(resourceName: "logo7")
        return imgView
    }()
    
    private let assetNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .gothamMedium(ofSize: 14)
        lbl.numberOfLines = 0
        lbl.textColor = .black
        return lbl
    }()
    
    private let assetSymbolLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .gothamThin(ofSize: 10)
        lbl.numberOfLines = 0
        lbl.textColor = .darkGray
        return lbl
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.gothamMedium(ofSize: 10)
        button.setImage(UIImage(named: "unchecked"), for: .normal)
        button.setImage(UIImage(named: "checked"), for: .selected)
        button.tintColor = .fwCyan
        return button
    }()

    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
           var frame = newFrame
            let newWidth = frame.width * 0.95 // get 90% width here
            let space = (frame.width - newWidth) / 2
            frame.size.width = newWidth
            frame.origin.x += space
            frame.origin.y += 10

            super.frame = frame
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        let labelStack = UIStackView(arrangedSubviews: [assetNameLabel, assetSymbolLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 0
        contentView.addSubview(followButton)
        followButton.anchor(right: rightAnchor, paddingRight: 20)
        followButton.centerY(inView: self)
        followButton.setDimensions(height: 25, width: 25)
        followButton.addTarget(self, action: #selector(handleFollowTapped(sender:)), for: .touchUpInside)

        
        addSubview(assetProfileImgVw)
        assetProfileImgVw.setDimensions(height: 40, width: 40)
        assetProfileImgVw.centerY(inView: self)
        assetProfileImgVw.anchor(left: leftAnchor, paddingLeft: 20)
        addSubview(labelStack)
        labelStack.anchor(top: topAnchor, left: assetProfileImgVw.rightAnchor, bottom: bottomAnchor, right: followButton.leftAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 35, paddingRight: 10)
  
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let separatorHeight = CGFloat(5)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: frame.size.height-separatorHeight, width:frame.size.width, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        self.addSubview(additionalSeparator)
    }
    
    
    func configure()  {
        guard let asset = asset else { return }
        assetNameLabel.text = asset.name
        assetSymbolLabel.text = asset.type
        
        if let profileImageString = asset.profileImageURL {
            guard let url = URL(string: profileImageString) else { return }
            assetProfileImgVw.sd_setImage(with: url)
        } else {
            assetProfileImgVw.image = #imageLiteral(resourceName: "icon6.png")
        }
     }
    
    
    @objc func handleFollowTapped(sender: UIButton)  {
        followButton.isSelected = !followButton.isSelected
        if followButton.isSelected {
            Vibration.light.vibrate()
        } else {
            Vibration.medium.vibrate()
        }

    }
}
