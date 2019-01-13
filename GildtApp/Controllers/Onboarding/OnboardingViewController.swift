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
        NSLocalizedString("Onboarding_Welcome", comment: ""),
        NSLocalizedString("Onboarding_Agenda", comment: ""),
        NSLocalizedString("Onboarding_Deals", comment: ""),
        NSLocalizedString("Onboarding_Stamps", comment: ""),
        NSLocalizedString("Onboarding_Jukebox", comment: ""),
        NSLocalizedString("Onboarding_Photos", comment: "")
    ]
    var subTitleArray: [String] = [
        NSLocalizedString("Onboarding_Welcome_Description", comment: ""),
        NSLocalizedString("Onboarding_Agenda_Description", comment: ""),
        NSLocalizedString("Onboarding_Deals_Description", comment: ""),
        NSLocalizedString("Onboarding_Stamps_Description", comment: ""),
        NSLocalizedString("Onboarding_Jukebox_Description", comment: ""),
        NSLocalizedString("Onboarding_Photos_Description", comment: "")
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
        if (!LocalStorageService.isAuthTokenSet()){
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginVc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVc, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let agendaPageVc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
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
            overlay.continueButton.setTitle(NSLocalizedString("Onboarding_Next", comment: ""), for: .normal)
            overlay.skipButton.setTitle(NSLocalizedString("Onboarding_Skip", comment: ""), for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle(NSLocalizedString("Onboarding_Open_App", comment: ""), for: .normal)
            overlay.skipButton.isHidden = true
        }
    }
}



