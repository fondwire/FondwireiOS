//
//  CustomTextField.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/10/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    init(withPlaceholder placeholder: String) {
        super.init(frame: .zero)
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        textColor = .white
        tintColor = .white
        borderStyle = .none
        keyboardAppearance = .dark
        backgroundColor = .fwDarkBlueBg
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.init(white: 0.5, alpha: 1).cgColor
        setHeight(height: 50)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.5)])
        font = UIFont.gothamBook(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
