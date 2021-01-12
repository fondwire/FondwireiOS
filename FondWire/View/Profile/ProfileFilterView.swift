//
//  ProfileFilterView.swift
//  FondWire
//
//  Created by Edil Ashimov on 8/24/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

private let filterViewReuseID = "ProfileFilterReuseID"

protocol ProfileFilterViewDelegate: class {
    func filterView(_ view: ProfileFilterView, didSelect index: Int)
}

class ProfileFilterView: UIView {
    
    //MARK: - Properties

    weak var delegate: ProfileFilterViewDelegate?
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .fwCyan
        return view
    }()
    
    //MARK: - Lifecycles

    override init(frame: CGRect) {
        super.init(frame:frame)
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: filterViewReuseID)
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.fwDarkBlueBg
        addSubview(lineView)
        lineView.anchor(top: bottomAnchor, left: leftAnchor, width:frame.width, height: 2)
        
        
        addSubview(underlineView)
        underlineView.anchor(top: bottomAnchor, left: leftAnchor, width:frame.width/2, height: 2)
        
      

        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - UICollectionViewDatasource

extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterViewReuseID, for: indexPath) as! ProfileFilterCell
        
       let option = ProfileFilterOptions(rawValue: indexPath.row)
        
        cell.option = option
        return cell
    }
}

//MARK: UICollectionViewDelegate

extension ProfileFilterView {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, didSelect: indexPath.row)
        let cell = collectionView.cellForItem(at: indexPath)
        let originX = cell?.frame.origin.x ?? 0
       
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = originX
        }
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(ProfileFilterOptions.allCases.count)
        return CGSize(width: frame.width / CGFloat(count), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
