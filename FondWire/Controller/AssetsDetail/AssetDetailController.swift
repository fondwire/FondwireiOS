//
//  AssetDetailController.swift
//  FondWire
//
//  Created by Edil Ashimov on 1/7/21.
//  Copyright © 2021 Edil Ashimov. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class AssetDetailController: UIViewController {
    
    @IBOutlet weak var assetLogoImgVw: UIImageView!
    @IBOutlet weak var assetTitleLbl: UILabel!
    @IBOutlet weak var assetTeaserTxtVw: UITextView!
    
    @IBOutlet weak var contactPersonImgVw: UIImageView!
    @IBOutlet weak var contactPersonNameLbl: UILabel!
    @IBOutlet weak var contactPersonPositionLbl: UILabel!
    @IBOutlet weak var contactPersonNumberLbl: UILabel!
    @IBOutlet weak var contactPersonEmailLbl: UILabel!
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        view.backgroundColor = UIColor.white
        contactPersonImgVw.layer.borderColor = UIColor.darkGray.cgColor
        contactPersonImgVw.layer.borderWidth = 1.0
        contactPersonImgVw.layer.cornerRadius = contactPersonImgVw.frame.size.width/2
        configureAsset()
    }
    
    func configureAsset()  {
        
        guard let asset = asset else { return }
        assetTitleLbl.text = asset.name
        if let teaser = asset.teaser {
            assetTeaserTxtVw.text = teaser
        }
        
        if let profileImageString = asset.profileImageURL {
            guard let url = URL(string: profileImageString) else { return }
            assetLogoImgVw.sd_setImage(with: url)
        }
        
        if asset.contactPerson != nil {
        contactPersonNameLbl.text = asset.contactPerson?.name
        contactPersonEmailLbl.text = asset.contactPerson?.email
        contactPersonPositionLbl.text = asset.contactPerson?.position
        contactPersonNumberLbl.text = asset.contactPerson?.phone
        }
        
        if let profileImageString = asset.contactPerson?.profileImageURL {
            guard let url = URL(string: profileImageString) else { return }
            contactPersonImgVw.sd_setImage(with: url)
        }
        
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        comingSoon()
    }
}

