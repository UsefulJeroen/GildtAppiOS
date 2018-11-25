//
//  LoginViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 25/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

//view isnt useable to register users, only login right now...
class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var firstTextField: UITextField!
    
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBAction func buttonTouched(_ sender: Any) {
        
        login()
    }
    
    func login() {
        
        let email: String = firstTextField.text!
        //show error if this is nil
        let password: String = secondTextField.text!
        //show error if this is nil
        
        let user: auth = auth(email: email, password: password)
        BackendAPIService.login(user: user)
            .response(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode(LoginPostBack.self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.successfullyLoggedIn(postBack: data!)
                    }
                }
            })
        
    }
    
    func successfullyLoggedIn(postBack: LoginPostBack) {
        LocalStorageService.setAuthToken(authToken: postBack.jwt)
        
    }
    
    //add method when clicked on return buttons
    //add methods when switching to register and back
    //make register methods
}
