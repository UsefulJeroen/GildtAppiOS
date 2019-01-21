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
        title = LocalStorageService.getUsername() ?? NSLocalizedString("General_Profile", comment: "")
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
    
    @IBAction func algemeneVoorwaardenTapped(_ sender: Any) {
//        let alertTitle = "Algemene voorwaarden"
//        let alertMessage = "Er zijn helaas nog geen algemene voorwaarden voor deze applicatie."
//        let discardText = "Ok :("
//        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: discardText, style: .default))
//        self.present(alert, animated: true)
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlgemeneVoorwaardenViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func overOntwikkelaarsTapped(_ sender: Any) {
        
    }
}
