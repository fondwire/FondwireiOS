//
//  LogoAnimationView.swift
//  FondWire
//
//  Created by Edil Ashimov on 1/9/21.
//  Copyright © 2021 Edil Ashimov. All rights reserved.
//

import UIKit
import SwiftyGif

class LogoAnimationView: UIView {
    
    let logoGifImageView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "logo.gif") else {
            return UIImageView()
        }
        return UIImageView(gifImage: gifImage, loopCount: 1)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(red: 27/255.0, green: 27/255.0, blue: 27/255.0, alpha: 1)
        addSubview(logoGifImageView)
        logoGifImageView.contentMode = .scaleAspectFit
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoGifImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        logoGifImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
}
