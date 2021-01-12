//
//  ProfileFilterCell.swift
//  FondWire
//
//  Created by Edil Ashimov on 8/24/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    
    var option: ProfileFilterOptions! {
        didSet {
            titleLbl.text = option.description
        }
    }
    
    let titleLbl: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test Filter"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLbl.font = isSelected ? UIFont.gothamBold(ofSize: 14) : UIFont.gothamBook(ofSize: 12)
            titleLbl.textColor = isSelected ? .fwCyan : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(titleLbl)
        titleLbl.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
