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
        title = LocalStorageService.getUsername() ?? R.string.localizable.general_Profile()
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
        let alertTitle = R.string.localizable.profile_AlgemeneVoorwaarden_title()
        let alertMessage = R.string.localizable.profile_AlgemeneVoorwaarden_message()
        let discardText = R.string.localizable.profile_AlgemeneVoorwaarden_discard()
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: discardText, style: .default))
        self.present(alert, animated: true)
    }
    
    @IBAction func overOntwikkelaarsTapped(_ sender: Any) {
        let alertTitle = R.string.localizable.profile_OverOntwikkelaars_title()
        let alertMessage = R.string.localizable.profile_OverOntwikkelaars_message()
        let discardText = R.string.localizable.profile_OverOntwikkelaars_discard()
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: discardText, style: .default))
        self.present(alert, animated: true)
    }
}
