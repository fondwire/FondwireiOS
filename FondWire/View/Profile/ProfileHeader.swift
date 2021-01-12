//
//  ProfileHeader.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/21/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import SDWebImage


protocol ProfileHeaderDelegate: class {
    func didSelect(filter: ProfileFilterOptions)
    func didTapProfileChangePhoto()

}

class ProfileHeader: UICollectionReusableView {
        
    weak var delegate: ProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            configureProfileInfo()
        }
    }
    var asset: Asset? {
          didSet {
              configureAssetProfileInfo()
          }
      }
    
    var profileImgVw: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profile_placeholder")
        imageView.backgroundColor = UIColor(white: 1, alpha: 1)
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    private let profileNameLbl: UILabel = {
        let label = UILabel()
        label.text = "SIGNED OUT"
        label.font = .gothamBold(ofSize: 20)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.text = "Financial Advisor, Fondwire"
        label.font = .gothamLight(ofSize: 10)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private var circleView: UIView!
    private var buttonsView = [UIView]()
    private let actionsStack = UIStackView()
    
    private let filterBar = ProfileFilterView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    
    
    func configureUI()  {
        backgroundColor = .white
        
        circleView = UIView()
        circleView.backgroundColor = .fwCyan
        circleView.alpha = 1
        circleView.setDimensions(height: frame.height * 0.25, width: frame.height*0.25)
        circleView.layer.cornerRadius = frame.height * 0.25/2
        addSubview(circleView)
        circleView.center(inView: self)
        
        circleView.addSubview(profileImgVw)
        profileImgVw.center(inView: circleView)
        profileImgVw.setDimensions(height: frame.height * 0.22, width: frame.height * 0.22)
        profileImgVw.layer.cornerRadius = frame.height * 0.22/2
        circleView.frame.origin.y = self.center.y-15
        let profileImgTap = UITapGestureRecognizer(target: self, action: #selector(changeProfilePhoto))
        profileImgVw.addGestureRecognizer(profileImgTap)
        
        
        let stack = UIStackView(arrangedSubviews: [profileNameLbl, positionLabel])
        stack.spacing = 5
        stack.axis = .vertical
        addSubview(stack)
        stack.anchor(top: circleView.bottomAnchor, paddingTop: -15)
        stack.centerX(inView: self)
        
        addSubview(actionsStack)
        actionsStack.anchor(top: stack.bottomAnchor, paddingTop: 15)
        actionsStack.centerX(inView: self)
        actionsStack.spacing = 10
        actionsStack.setDimensions(height: 30, width: frame.width*0.7)
        actionsStack.distribution = .fillEqually
        
        filterBar.delegate = self
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 0, height: 40)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.frame.origin.y -= frame.height*0.1
    }
    
    //MARK: Helpers

    func configureProfileInfo() {
        
        if let user = user {
            let viewModel = ProfileHeaderViewModel(user: user)
            profileNameLbl.text = viewModel.fullName
            
            if let profileImageURL = user.profileImageUrl {
                profileImgVw.sd_setImage(with: user.profileImageUrl)
            } else {
                profileImgVw.image = #imageLiteral(resourceName: "profile_placeholder")
            }
            positionLabel.text = user.companyName
        } else {
            profileNameLbl.text = "SIGNED OUT"
            profileImgVw.image = #imageLiteral(resourceName: "profile_placeholder")
        }
    }
    
    func configureAssetProfileInfo() {
           
           if let asset = asset {
            
            profileNameLbl.text = asset.name
            positionLabel.text = asset.type
            
//            let viewModel = ProfileHeaderViewModel(asset: asset)
//               profileNameLbl.text = viewModel.fullName
//
//               if let profileImageURL = user.profileImageUrl {
//                   profileImgVw.sd_setImage(with: user.profileImageUrl)
//               } else {
//                   profileImgVw.image = #imageLiteral(resourceName: "profile_placeholder")
//               }
//               positionLabel.text = user.companyName
//           } else {
//               profileNameLbl.text = "SIGNED OUT"
//               profileImgVw.image = #imageLiteral(resourceName: "profile_placeholder")
           }
       }

    
    //MARK: Selectors
    
    @objc func changeProfilePhoto() {
        delegate?.didTapProfileChangePhoto()
    }
      
}


    
//MARK: ProfileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {

    func filterView(_ view: ProfileFilterView, didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        delegate?.didSelect(filter: filter)
    }
}
