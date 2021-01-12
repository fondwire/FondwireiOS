//
//  MessageActionsCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/18/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class MessageActionsCollectionCell: UICollectionViewCell {
    
    private let titleImgVw: UIImageView = {
        
        let imageView = UIImageView()
        imageView.setDimensions(height: 40, width: 40)
        imageView.tintColor = .fwCyan
        imageView.contentMode = .scaleAspectFit
        return imageView

    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "NEW MESSAGE"
        label.font = .gothamBold(ofSize: 10)
        label.textColor = .fwCyan
        return label
    }()
    
    var actionTitle: MessageButtonActions! {
          didSet {
              titleLbl.text = actionTitle.description
          }
      }
    
    var actionIcon: MessageButtonActions! {
        didSet {
            titleImgVw.image = actionIcon.icon.withAlignmentRectInsets(UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(white: 0.95, alpha: 1)
        layer.cornerRadius = 20

        
        let stack = UIStackView(arrangedSubviews: [titleImgVw, titleLbl])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        addSubview(stack)
        stack.center(inView: self)
        stack.setDimensions(height: 70, width: 90)
    }
    
    func configureCornerRadius(forButtonWithTitle title: MessageButtonActions) {
        switch title {

        case .newMessage:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,  .layerMinXMaxYCorner]
        case .newReport:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case .feedback:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner,  .layerMinXMaxYCorner]
        case .other:
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner,  .layerMinXMaxYCorner]
        }
    }
    override func layoutSubviews() {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
