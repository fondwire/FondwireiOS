//
//  LaunchController.swift
//  FondWire
//
//  Created by Edil Ashimov on 1/9/21.
//  Copyright © 2021 Edil Ashimov. All rights reserved.
//

import UIKit
import SwiftyGif

class LaunchController: UIViewController {


    let logoAnimationView = LogoAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }

}

extension LaunchController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true

    }
}

