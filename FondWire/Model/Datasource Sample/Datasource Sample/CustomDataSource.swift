//
//  CustomDataSource.swift
//  Datasource Sample
//
//  Created by Edil Ashimov on 12/13/20.
//

import UIKit

class CustomDataSource: NSObject, UICollectionViewDataSource {
    
    private var data: [String]!
    private var collectionView: UICollectionView!
    init(collectionView: UICollectionView, data: [String]!) {
        super.init()
        
        self.data = data
        self.collectionView = collectionView
        self.collectionView.dataSource = self
    }
    
    deinit {
        print("Custom Data Source is Deinit")
    }
}

extension CustomDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCell
        cell.titleLabel.text = data[indexPath.row]
        return cell
    }
}
