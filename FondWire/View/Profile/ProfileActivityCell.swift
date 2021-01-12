//
//  ProfileActivityCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 8/24/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class ProfileActivityCell: UICollectionViewCell {

    // MARK: - Lifecycle

     override init(frame: CGRect) {
         super.init(frame: frame)
//        backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(0.20)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: 100-separatorHeight, width: screenSize.width, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor.fwMatteDarkBlue
        self.addSubview(additionalSeparator)
        
        let stack = UIStackView(arrangedSubviews: [titleLbl, descripLbl, dateLbl])
        stack.spacing = 10
        stack.setCustomSpacing(7, after: descripLbl)
        stack.axis = .vertical
        stack.alignment = .leading
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 25, constant: 0)
        stack.anchor(right: rightAnchor, paddingRight: 20)

     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func layoutSubviews() {
//        backgroundColor = UIColor.init(white: 0.95, alpha: 1)
    }
    
    
private let titleLbl: UILabel = {
       let label = UILabel()
       label.text = "You found an article useful"
       label.font = .gothamMedium(ofSize: 13)
       label.textAlignment = .left
       label.numberOfLines = 1
    label.textColor = .black
       return label
   }()
   
    private let descripLbl: UILabel = {
        let label = UILabel()
        label.text = "Blockchain technology background. Cryptocurrency fintech block chain network and programming concept. Abstract Segwit."
        label.font = .gothamLight(ofSize: 10)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .darkGray
        return label
    }()
   
   private let dateLbl: UILabel = {
       let label = UILabel()
       label.text = "06/18/2020 11:52 AM"
       label.font = .gothamLight(ofSize: 10)
       label.textAlignment = .left
       label.numberOfLines = 1
    label.textColor = .darkGray
       return label
   }()
}


