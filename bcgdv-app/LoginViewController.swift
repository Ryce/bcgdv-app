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

class LoginViewController: UITableViewController {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var session: Session!
    
    var delegate: LoginViewControllerDelegate?
    
    @IBAction func login() {
        guard let userNameString = userNameTextField.text, userNameString.characters.count > 0, let passwordString = passwordTextField.text, passwordString.characters.count > 0 else {
            self.showError("Please enter all the details")
            return
        }
        
        let parameters = ["" : userNameString, "" : passwordString]
        
        self.session.createSession(parameters: parameters) { (result) in
            switch result {
            case .success(let user):
                self.delegate?.loginViewController(viewController: self, didLoginWithUser: user)
            case .failure(let error):
                // TODO: handle error
                self.showError(error.localizedDescription)
            }
        }
        
    }
    
    func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
