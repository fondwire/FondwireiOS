//
//  File.swift
//  FondWire
//
//  Created by Edil Ashimov on 12/13/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import UIKit

final class DataService {
    
    static let shared = DataService()
    var assets: [Asset] = []
    var feeds: [Feed]? = []
    private init() {}
}

