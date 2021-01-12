//
//  MessageHeaderView.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/18/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class MessageHeaderView: UIView {
    private let actionsView = MessageActionsView()
        
        override init(frame: CGRect) {
        super.init(frame: frame)
        
            backgroundColor = .white
        addSubview(actionsView)
        actionsView.center(inView: self)
        actionsView.setDimensions(height: 270, width: 260)
        actionsView.anchor(top: topAnchor, paddingTop: 30)
    }
    
    override func layoutSubviews() {
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(0.25)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: frame.height-separatorHeight, width: screenSize.width, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor(white: 0.3, alpha: 1)
        self.addSubview(additionalSeparator)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
