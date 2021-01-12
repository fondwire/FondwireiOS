//
//  AuthButton.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/10/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class AuthButton: UIButton {
    
     var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        layer.cornerRadius = 5
        backgroundColor = UIColor.fwYellow.withAlphaComponent(0.5)
        setTitleColor(UIColor(white: 0, alpha: 0.67), for: .normal)
        setHeight(height: 50)
        isEnabled = false
        setTitle("Log In", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
