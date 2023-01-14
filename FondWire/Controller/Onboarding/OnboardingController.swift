//
//  OnboardingController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/13/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import paper_onboarding

protocol OnboardingControllerDelegate: class {
    func onboardingWasSeen()
}

class OnboardingController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: OnboardingControllerDelegate?
    private var onboardingItems = [OnboardingItemInfo]()
    private var onboardingView = PaperOnboarding()
    
    private let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GET STARTED", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.gothamBold(ofSize: 16)
        button.addTarget(self, action: #selector(handleGetStartedTapped), for: .touchUpInside)
        button.backgroundColor = .fwYellow
        button.layer.cornerRadius = 25
        return button
    }()
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super .viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        configureUI()
        configureOnboardingDataSource()
    }
  
    //MARK: - Helpers
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func animateGetStartedButton(_ shouldShow: Bool) {
        let alpha: CGFloat = shouldShow ? 1 : 0
        UIView.animate(withDuration: 0.5) {
            self.getStartedButton.alpha = alpha
            Vibration.light.vibrate()

            
        }
    }
    
    func configureUI() {
        view.addSubview(onboardingView)
        onboardingView.fillSuperview()
        view.addSubview(getStartedButton)
        getStartedButton.centerX(inView: view)
        getStartedButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 100)
        getStartedButton.alpha = 0
        getStartedButton.setDimensions(height: 50, width: view.frame.width * 0.75)
        onboardingView.delegate = self
    }
    
    func configureOnboardingDataSource() {
        
        let insights = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "insights").withRenderingMode(.alwaysOriginal), title: TITLE_INSIGHTS, description: DESCRIPTION_INSIGHTS, pageIcon: UIImage(), color: .fwDarkBlueBg, titleColor: .white, descriptionColor: .white, titleFont: UIFont.gothamBold(ofSize: 20), descriptionFont: UIFont.gothamBook(ofSize: 16))
        
        let explore = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "explore").withRenderingMode(.alwaysOriginal), title: TITLE_EXPLORE, description: DESCRIPTION_EXPLORE, pageIcon: UIImage(), color: .fwDarkBlueBg, titleColor: .white, descriptionColor: .white, titleFont: UIFont.gothamBold(ofSize: 20), descriptionFont: UIFont.gothamBook(ofSize: 16))
       
        let manage = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "manage").withRenderingMode(.alwaysOriginal), title: TITLE_MANAGE, description: DESCRIPTION_MANAGE, pageIcon: UIImage(), color: .fwDarkBlueBg, titleColor: .white, descriptionColor: .white, titleFont: UIFont.gothamBold(ofSize: 20), descriptionFont: UIFont.gothamBook(ofSize: 16))
        
        onboardingItems.append(insights)
        onboardingItems.append(explore)
        onboardingItems.append(manage)

        onboardingView.dataSource = self
        onboardingView.reloadInputViews()
        
        
    }
    
    //MARK: - Selectors

    @objc func handleGetStartedTapped() {
        
        let controller = TermsAgreementController()
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        controller.delegate = self
        present(controller, animated: true, completion:nil)
        Vibration.medium.vibrate()

        

    }
}

extension OnboardingController: PaperOnboardingDataSource {
    func onboardingItemsCount() -> Int {
        return onboardingItems.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onboardingItems[index]
    }
}

extension OnboardingController: PaperOnboardingDelegate {
    func onboardingWillTransitonToIndex(_ index: Int) {
        let viewModel = OnboardingViewModel(itemCount: onboardingItems.count)
        let shouldShow = viewModel.shouldShowGetStartedButton(forIndex: index)
        animateGetStartedButton(shouldShow)
    }
}

extension OnboardingController: TermsAgreementControllerDelegate {
    func didAgreeToTerms() {
        dismiss(animated: false, completion: {
            self.delegate?.onboardingWasSeen()
        })
    }
    
    
}
