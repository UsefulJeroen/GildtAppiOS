//
//  LoginViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 25/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var wantAccountButton: UIButton!
    @IBOutlet weak var haveAccountButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeViewToLogin()
    }
    
    func emptyAllFields() {
        firstTextField.text = ""
        firstTextField.endEditing(true)
        secondTextField.text = ""
        secondTextField.endEditing(true)
        thirdTextField.text = ""
        thirdTextField.endEditing(true)
        fourthTextField.text = ""
        fourthTextField.endEditing(true)
    }
    
    func changeViewToRegister() {
        emptyAllFields()
        loginButton.isHidden = true
        wantAccountButton.isHidden = true
        
        thirdTextField.isHidden = false
        fourthTextField.isHidden = false
        registerButton.isHidden = false
        haveAccountButton.isHidden = false
        
        firstTextField.placeholder = "Gebruikersnaam"
        firstTextField.keyboardType = UIKeyboardType.alphabet
        firstTextField.returnKeyType = UIReturnKeyType.next
        
        secondTextField.placeholder = "Emailadres"
        secondTextField.keyboardType = UIKeyboardType.emailAddress
        secondTextField.isSecureTextEntry = false
        secondTextField.returnKeyType = UIReturnKeyType.next
        
        thirdTextField.placeholder = "Wachtwoord"
        thirdTextField.keyboardType = UIKeyboardType.default
        thirdTextField.isSecureTextEntry = true
        thirdTextField.returnKeyType = UIReturnKeyType.next
        
        fourthTextField.placeholder = "Wachtwoord verificatie"
        fourthTextField.keyboardType = UIKeyboardType.default
        fourthTextField.isSecureTextEntry = true
        fourthTextField.returnKeyType = UIReturnKeyType.go
        
        haveAccountButton.setTitle("Heb je al een account?", for: UIControl.State.normal)
    }
    
    func changeViewToLogin() {
        emptyAllFields()
        thirdTextField.isHidden = true
        fourthTextField.isHidden = true
        registerButton.isHidden = true
        haveAccountButton.isHidden = true
        
        loginButton.isHidden = false
        wantAccountButton.isHidden = false
        
        firstTextField.placeholder = "Emailadres"
        firstTextField.keyboardType = UIKeyboardType.emailAddress
        firstTextField.returnKeyType = UIReturnKeyType.next
        
        secondTextField.placeholder = "Wachtwoord"
        secondTextField.keyboardType = UIKeyboardType.default
        secondTextField.isSecureTextEntry = true
        secondTextField.returnKeyType = UIReturnKeyType.go
        
        wantAccountButton.setTitle("Heb je nog geen account?", for: UIControl.State.normal)
    }
    
    //function that returns which part of the view is used
    //is it used to login? or register?
    //if register is selected; return true
    //if login is selected; return false
    func needsToRegister() -> Bool {
        if segmentedControl.selectedSegmentIndex == 0 {
            return true
        }
        if segmentedControl.selectedSegmentIndex == 1 {
            return false
        }
        print("this really shouldn't happen")
        return false
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        login()
    }
    
    @IBAction func wantAccountButtonTouched(_ sender: Any) {
        segmentedControl.selectedSegmentIndex = 0
        changeViewToRegister()
    }
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        register()
    }
    
    @IBAction func haveAccountButtonTouched(_ sender: Any) {
        segmentedControl.selectedSegmentIndex = 1
        changeViewToLogin()
    }
    
    func login() {
        activityIndicator.isHidden = false
        let email: String = firstTextField.text!
        //show error if this is nil
        let password: String = secondTextField.text!
        //show error if this is nil
        
        let user: LoginModel = LoginModel(email: email, password: password)
        UserAPIService.login(user: user)
            .response(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode(LoginPostBack.self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.successfullyLoggedIn(postBack: data!)
                    }
                    else {
                        self?.couldntLoginError()
                    }
                }
            })
    }
    
    func couldntLoginError() {
        activityIndicator.isHidden = true
        let alertTitle = "Kan niet inloggen :("
        let alertMessage = "Het is helaas niet gelukt om in te loggen, je hebt waarschijnlijk niet de juiste info ingevuld."
        let discardText = "Probeer het eens opnieuw"
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: discardText, style: .cancel, handler: { action in
            self.firstTextField.becomeFirstResponder()
        }))
        
        self.present(alert, animated: true)
    }
    
    func couldntRegisterError(error: ErrorMessage?) {
        activityIndicator.isHidden = true
        let alertTitle = "Kan niet registreren :("
        var alertMessage = "Het is helaas niet gelukt om je te registreren, waarschijnlijk omdat je iets verkeerds hebt ingevuld."
        if let error = error {
            alertMessage = "Het is helaas niet gelukt om je te registreren, omdat: \(error.message)"
        }
        let discardText = "Probeer het eens opnieuw"
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: discardText, style: .cancel, handler: { action in
            self.firstTextField.becomeFirstResponder()
        }))
        
        self.present(alert, animated: true)
    }
    
    func successfullyLoggedIn(postBack: LoginPostBack) {
        activityIndicator.isHidden = true
        LocalStorageService.setAuthToken(authToken: postBack.jwt)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let agendaPageVc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        self.present(agendaPageVc, animated: true, completion: nil)
    }
    
    func register() {
        activityIndicator.isHidden = false
        let username: String = firstTextField.text!
        //show error if this is nil
        let email: String = secondTextField.text!
        //show error if this is nil
        let password: String = thirdTextField.text!
        //show error if this is nil
        let passwordConfirmation: String = fourthTextField.text!
        //show error if this is nil
        
        let user: RegisterModel = RegisterModel(username: username, email: email, password: password, password_confirmation: passwordConfirmation)
        UserAPIService.register(user: user)
            .response(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let loginPostBack: LoginPostBack? = try? decoder.decode(LoginPostBack.self, from: jsonData)
                if let loginPostBack = loginPostBack {
                    DispatchQueue.main.async {
                        self?.successfullyLoggedIn(postBack: loginPostBack)
                    }
                }
                else {
                    let errorMessage = try? decoder.decode(ErrorMessage.self, from: jsonData)
                    DispatchQueue.main.async {
                        self?.couldntRegisterError(error: errorMessage)
                    }
                }
                
            })
    }
    
    //when changing the register/login switch segmentedcontrol
    @IBAction func segmentedControlClicked(_ sender: Any) {
        if needsToRegister() {
            changeViewToRegister()
        }
        else {
            changeViewToLogin()
        }
    }
    
    //when return button is pressed when first textfield while used
    @IBAction func firstTextFieldTrigger(_ sender: Any) {
        // TODO: check of het veld goed is ingevuld
        firstTextField.endEditing(true)
        secondTextField.becomeFirstResponder()
    }
    
    //when return button is pressed when second textfield while used
    @IBAction func secondTextFieldTrigger(_ sender: Any) {
        secondTextField.endEditing(true)
        if needsToRegister() {
            // TODO: check of het veld goed is ingevuld
            thirdTextField.becomeFirstResponder()
        }
        else {
            // TODO: check of het veld goed is ingevuld
            login()
        }
    }

    //when return button is pressed when third textfield while used
    @IBAction func thirdTextFieldTrigger(_ sender: Any) {
        if needsToRegister() {
            // TODO: check of het veld goed is ingevuld
            thirdTextField.endEditing(true)
            fourthTextField.becomeFirstResponder()
        }
    }

    //when return button is pressed when fourth textfield while used
    @IBAction func fourthTextFieldTrigger(_ sender: Any) {
        if needsToRegister() {
            // TODO: check of het veld goed is ingevuld
            fourthTextField.endEditing(true)
            register()
        }
    }
    
    
    //hide keyboard when pressing outside textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}