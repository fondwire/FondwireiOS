//
//  OnboardingViewModel.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/15/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import paper_onboarding

struct OnboardingViewModel {
    private let itemCount: Int
    
    init(itemCount: Int) {
        self.itemCount = itemCount
    }
    
    func shouldShowGetStartedButton(forIndex index: Int) -> Bool {
        return index == itemCount - 1 ? true : false
    }
}
