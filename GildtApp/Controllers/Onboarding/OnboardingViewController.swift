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
        "Welkom!",
        "Agenda",
        "Deals",
        "Stempelkaart",
        "Jukebox",
        "Foto's"
    ]
    var subTitleArray: [String] = [
        "Hier een kleine uitleg over de app van ’t Gildt\n\nEr zijn 5 basisfuncties beschikbaar voor de gasten van ’t Haerlems Studenten Gildt",
        "De agenda laat zien wat de aankomende evenementen zijn. Je kunt aangeven of je aanwezig zult zijn en je kan zien wie er ook naar het evenement komt. Zorg dus voor een leuke gebruikersnaam!",
        "Deals laat je jouw coupons zien. Vanuit dit scherm kan de bar-medewerker jouw coupon verzilveren. Sommige deals zijn onbeperkt beschikbaar andere hebben een maximum per gebruiker.",
        "De stempelkaart laat zien hoeveel stempels je al hebt gespaard en je kan een stempel claimen als je aanwezig bent op een stempel-evenement.\nMet een volle stempelkaart zijn prijzen te winnen!",
        "Bij de jukebox kunnen er muzieknummers worden aangevraagd om af te spelen in ’t Gildt.\nOok kan er ge-upvote en ge-downvote worden op eerder aangevraagde nummers.",
        "Bij de foto’s worden er tags getoont. De tag ‘Halloween’ bevat bijvoorbeeld foto’s van het thema-feest ‘Halloween’. Ook kan je hier zelf foto’s van thema-feesten  uploaden."
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
            overlay.continueButton.setTitle("Volgende", for: .normal)
            overlay.skipButton.setTitle("Skip", for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle("Open de app!", for: .normal)
            overlay.skipButton.isHidden = true
        }
    }
}



