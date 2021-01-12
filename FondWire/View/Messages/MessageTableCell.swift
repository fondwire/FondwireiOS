//
//  MessageTableCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/18/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class MessageTableCell: UITableViewCell {
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "Welcome To Insights"
        label.font = .gothamMedium(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    private let descripLbl: UILabel = {
        let label = UILabel()
        label.text = "You just joined Insights, you can learn more about it by going to the link provide"
        label.font = .gothamLight(ofSize: 10)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .darkGray
        return label
    }()
    
    private let dateLbl: UILabel = {
        let label = UILabel()
        label.text = "06/18/2020 11:52 AM"
        label.font = .gothamThin(ofSize: 10)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
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
}
