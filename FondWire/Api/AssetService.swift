//
//  AssetService.swift
//  FondWire
//
//  Created by Edil Ashimov on 9/26/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct AssetService {
    
    static let shared =  AssetService()
     
    func createNewAsset(companyName: String, managerUid: String, managerName: String, companyType: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
       
        let managers = [managerName: managerUid]
        let values = ["managers": managers, "type": companyType] as [String : Any]
        let assetValues = [companyName: values] as [String : Any]
        
        REF_ASSETS.updateChildValues(assetValues, withCompletionBlock: completion)
    }
    
    func addNewManager(companyName: String, managers: [String : Any], completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        let values = ["managers": managers]
        let assetValues = [companyName: values]
        
        REF_ASSETS.updateChildValues(assetValues, withCompletionBlock: completion)
     }
    
    func fetchAssets(completion: @escaping([Asset]) -> Void) {
        var assets = [Asset]()
        
        REF_ASSETS.observeSingleEvent(of: .value) { (snapshot) in
            guard let snap = snapshot.value as? [String: Any] else { return }
            for (key, value) in snap  {
                let dict = value as! [String : Any]
                let managers = dict["managers"]
                var asset: Asset!
                if let contact = dict["contact"] {
                    asset = Asset(name: key, type: dict["type"] as! String, teaser: dict["teaser"] as? String, managers: managers as? [String : Any], profileImageURL: dict["profileImageURL"] as? String, contactPerson: ContactPerson(dictionary: contact as! [String : AnyObject]))
                } else {
                    asset = Asset(name: key, type: dict["type"] as! String, teaser: dict["teaser"] as? String, managers: managers as? [String : Any], profileImageURL: dict["profileImageURL"] as? String)
                }
                assets.append(asset)

                

            }
            completion(assets)
        }
    }
}
