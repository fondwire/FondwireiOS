//
//  AuthViewModel.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/12/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

protocol FormViewModel {
    func updateForm() 
}

protocol AuthViewModel {
    var formIsValid: Bool { get }
    var shouldEnableButton: Bool { get }
    var buttonTitleColor: UIColor { get }
    var buttonBackgroundColor: UIColor { get }
}

struct LoginViewModel: AuthViewModel {
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
    
    var shouldEnableButton: Bool {
        return formIsValid
    }
    
    var buttonTitleColor: UIColor {
        return .black
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor.fwYellow : UIColor.fwYellow.withAlphaComponent(0.5)
    }   
}

struct SignUpViewModel: AuthViewModel {
    
    var email: String?
    var password: String?
    var fullname: String?
    var confirmPassword: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullname?.isEmpty == false
            && confirmPassword?.isEmpty == false
    }
    
    var shouldEnableButton: Bool {
        return formIsValid
    }
    
    var buttonTitleColor: UIColor {
        return .black 
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor.fwYellow : UIColor.fwYellow.withAlphaComponent(0.5)
    }
}

struct ResetPasswordViewModel: AuthViewModel {
    
    var email: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
    }
    
    var shouldEnableButton: Bool {
        return formIsValid
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .black : UIColor(white: 1, alpha: 0.67)
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor.fwYellow : UIColor.fwYellow.withAlphaComponent(0.5)
    }
}

struct CompanyInfoViewModel: AuthViewModel {
    
    var companyName: String?
    
    var companyType: String?

    
    var formIsValid: Bool {
           return companyName?.isEmpty == false
        && companyType?.isEmpty == false
       }
    
    var shouldEnableButton: Bool {
        return formIsValid
    }
    
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .black : UIColor(white: 1, alpha: 0.67)
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor.fwYellow : UIColor.fwYellow.withAlphaComponent(0.5)
    }
    
    
}
