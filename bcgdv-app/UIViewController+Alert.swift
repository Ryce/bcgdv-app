//
//  UIViewController+Alert.swift
//  bcgdv-app
//
//  Created by Hamon Riazy on 19/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ alertMessage: String) {
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
