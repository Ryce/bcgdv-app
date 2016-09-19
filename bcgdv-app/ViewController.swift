//
//  ViewController.swift
//  bcgdv-app
//
//  Created by Hamon Riazy on 19/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    
    let session = Session()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if getToken() == nil {
            let loginViewController = LoginViewController.instantiateFromStoryboard()
            loginViewController.delegate = self
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    
    
}

extension ViewController: LoginViewControllerDelegate {
    
    func loginViewController(viewController: LoginViewController, didLoginWithUser user: User) {
        // TODO: update info
    }
    
}
