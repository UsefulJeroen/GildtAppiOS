//
//  BaseViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 29/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class NavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButtons()
    }
    
    func setupNavigationButtons() {
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Profiel", style: .plain, target: self, action: #selector(profileClicked))
    }
    
    @objc func profileClicked() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let loginPageVc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        pushViewController(loginPageVc, animated: true)
    }
}
