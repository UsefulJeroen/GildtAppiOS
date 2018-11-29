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
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutClicked))
    }
    
    @objc func logoutClicked() {
        LocalStorageService.removeAuthToken()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginPageVc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        present(loginPageVc, animated: true, completion: nil)
    }
}
