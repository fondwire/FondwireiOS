//
//  DeviceUtility.swift
//  FondWire
//
//  Created by Edil Ashimov on 5/18/21.
//  Copyright © 2021 Edil Ashimov. All rights reserved.
//

import UIKit

struct Device {
    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
    static let isTV = UIDevice.current.userInterfaceIdiom == .tv
    static let isCar = UIDevice.current.userInterfaceIdiom == .carPlay
}
