//
//  ViewController.swift
//  Datasource Sample
//
//  Created by Edil Ashimov on 12/13/20.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {

    let data: [String] = {
        (1...100).map { "Test \($0)"}
    }()
    
    var dataSource: CustomDataSource?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = CustomDataSource(collectionView: collectionView, data: data)
    }

    deinit {
        print("Test VC Deinit")
    }

}

