//
//  ProfileTableCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/20/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
        let titleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "pen_icon"), for: .normal)
        button.setTitle("Me", for: .normal)
        button.titleLabel?.font = .gothamBold(ofSize: 15)
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 30, bottom: 0, right: 0.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 20, bottom: 0, right: 5)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let checkmarkImgVw: UIImageView = {
        let imageVw = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageVw.contentMode = .scaleAspectFit
        return imageVw
    }()
    
   // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
      
        
        addSubview(titleButton)
        titleButton.addConstraintsToFillView(self)
        titleButton.anchor(left: leftAnchor, paddingLeft: 20)
    }
    
    @objc func settingsButtonTapped() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
