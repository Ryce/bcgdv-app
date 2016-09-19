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
    
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    
    let session = Session()
    var user: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.choosePicture))
        self.imageView.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if getToken() == nil {
            let loginNavigationController = LoginNavigationViewController.instantiateFromStoryboard()
            guard let loginViewController = loginNavigationController.viewControllers[0] as? LoginViewController else { fatalError() }
            loginViewController.delegate = self
            loginViewController.session = self.session
            
            self.present(loginNavigationController, animated: true, completion: nil)
        }
    }
    
    
    func choosePicture() {
        
        let actionSheet = UIAlertController(title: "Source", message: "", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alertAction) in
                self.presentWithPickerType(.camera)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alertAction) in
            self.presentWithPickerType(.savedPhotosAlbum)
        }))
        
    }
    
    
    func presentWithPickerType(_ pickerType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = pickerType
        
        self.present(picker, animated: true, completion: nil)
    }
    
}

extension ViewController: LoginViewControllerDelegate {
    
    func loginViewController(viewController: LoginViewController, didLoginWithUser user: User) {
        self.user = user
        self.emailLabel.text = self.user?.email
        self.passwordLabel.text = self.user?.password
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return } // BAIL
        self.imageView.image = chosenImage
        
        let resizedImage = chosenImage.resizeWith(width: 600)!
        
        self.session.updateUserAvatar(withUser: self.user!, avatar: resizedImage, completion: ({ result in
            switch result {
            case .success(let user):
                self.user = user
                // TODO: update interface
            case .failure(let error):
                self.showAlert(error.localizedDescription)
            }
        }))
        
        self.dismiss(animated: true, completion: nil)
    }
}
