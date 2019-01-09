//
//  ProfileViewController.swift
//  GildtApp
//
//  Created by Wouter Janson on 05/01/2019.
//  Copyright © 2019 Gildt. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalStorageService.getUsername() ?? "Profiel"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        LocalStorageService.removeAuthToken()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginPageVc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        present(loginPageVc, animated: true, completion: nil)
    }
}