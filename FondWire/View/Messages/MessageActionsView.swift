//
//  MessageActionsView.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/18/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import ProgressHUD

private let actionsReuseID = "messageActionsCell"

class MessageActionsView: UIView {
    
    //MARK: - Properties

    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    

    //MARK: - Lifecycles

    override init(frame: CGRect) {
        super.init(frame:frame)
        
        collectionView.register(MessageActionsCollectionCell.self, forCellWithReuseIdentifier: actionsReuseID)
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.addConstraintsToFillView(self)
        collectionView.frame.size = CGSize(width: frame.width*0.95, height: frame.height*0.95)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}


//MARK: - UICollectionViewDatasource

extension MessageActionsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MessageButtonActions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: actionsReuseID, for: indexPath) as! MessageActionsCollectionCell
        
        guard let action = MessageButtonActions(rawValue: indexPath.row) else { return cell }
        cell.actionTitle = action
        cell.actionIcon = action
        cell.configureCornerRadius(forButtonWithTitle: action)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ProgressHUD.showSuccess("This feature in under implementation", image: #imageLiteral(resourceName: "fondwireLogo"), interaction: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MessageActionsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(MessageButtonActions.allCases.count)
        return CGSize(width: 125, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}




