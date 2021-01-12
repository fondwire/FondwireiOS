//
//  MessagesViewModel.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/18/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

enum MessageButtonActions: Int, CaseIterable {
    case newMessage
    case newReport
    case feedback
    case other
    
    var description: String {
        switch self {
        case .newMessage: return "NEW MESSAGE"
        case .newReport: return "NEW REPORT"
        case .feedback: return "FEEDBACK"
        case .other: return "OTHER"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .newMessage: return UIImage(systemName: "bubble.left.fill")!
        case .newReport: return UIImage(systemName: "flag.fill")!
        case .feedback: return UIImage(systemName: "bell.fill")!
        case .other: return UIImage(systemName: "ellipsis")!
        }
    }
}
