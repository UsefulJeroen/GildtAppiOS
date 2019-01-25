//
//  OnboardingViewController.swift
//  GildtApp
//
//  Created by Wouter Janson on 10/01/2019.
//  Copyright © 2019 Gildt. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var swiftyOnboard: SwiftyOnboard!
    var titleArray: [String] = [
        R.string.localizable.onboarding_Welcome(),
        R.string.localizable.onboarding_Agenda(),
        R.string.localizable.onboarding_Deals(),
        R.string.localizable.onboarding_Stamps(),
        R.string.localizable.onboarding_Jukebox(),
        R.string.localizable.onboarding_Photos()
    ]
    var subTitleArray: [String] = [
        R.string.localizable.onboarding_Welcome_Description(),
        R.string.localizable.onboarding_Agenda_Description(),
        R.string.localizable.onboarding_Deals_Description(),
        R.string.localizable.onboarding_Stamps_Description(),
        R.string.localizable.onboarding_Jukebox_Description(),
        R.string.localizable.onboarding_Photos_Description()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .gildt)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc func handleSkip() {
        exitOnboardingFlow()
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        
        if index == titleArray.count - 1 {
            exitOnboardingFlow()
        }
        
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
    
    func exitOnboardingFlow() {
        LocalStorageService.setOnboardingState(state: true)
        if (!LocalStorageService.isAuthTokenSet()) {
            let loginVc = R.storyboard.login.loginViewController()!
            self.present(loginVc, animated: true, completion: nil)
        } else {
            let agendaPageVc = R.storyboard.main.mainTabBarController()!
            self.present(agendaPageVc, animated: true, completion: nil)
        }
    }
}

extension OnboardingViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return titleArray.count
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        return .appBackground
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()
        
        view.imageView.image = UIImage(named: "Onboarding_\(index)")
        
        view.title.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        view.title.text = titleArray[index]
        
        view.subTitle.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        view.subTitle.text = subTitleArray[index]
        
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = Int(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.continueButton.tag = Int(position)
        
        if currentPage < titleArray.count - 1 {
            overlay.continueButton.setTitle(R.string.localizable.onboarding_Next(), for: .normal)
            overlay.skipButton.setTitle(R.string.localizable.onboarding_Skip(), for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle(R.string.localizable.onboarding_Open_App(), for: .normal)
            overlay.skipButton.isHidden = true
        }
    }
}



