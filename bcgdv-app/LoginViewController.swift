//
//  LoginViewController.swift
//  bcgdv-app
//
//  Created by Hamon Riazy on 19/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func loginViewController(viewController: LoginViewController, didLoginWithUser user: User)
}

class LoginNavigationViewController: UINavigationController { }

class LoginViewController: UITableViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var session: Session!
    
    var delegate: LoginViewControllerDelegate?
    
    @IBAction func login() {
        guard let emailString = emailTextField.text, emailString.characters.count > 0,
            let passwordString = passwordTextField.text, passwordString.characters.count > 0 else {
            self.showAlert("Please enter all the details")
            return
        }
        
        let parameters = ["email" : emailString, "password" : passwordString]
        
        self.session.createSession(parameters: parameters) { (result) in
            switch result {
            case .success(let user):
                self.delegate?.loginViewController(viewController: self, didLoginWithUser: user)
            case .failure(let error):
                self.showAlert(error.localizedDescription)
            }
        }
        
    }
    
}
