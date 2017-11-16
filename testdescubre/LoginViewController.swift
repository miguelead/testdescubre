//
//  LoginViewController.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/15/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func continuarConFacebook(_ sender: Any) {
        CurrentUser.shared = CurrentUser(id: 6, nombre: "Luis", mail: "ejemplo@gmail.com", location: "Puerto ordaz, Bolivar, Venezuela")
        performSegue(withIdentifier: "sucessfulLogin", sender: nil)
    }
    
    @IBAction func loginUser(_ sender: Any) {
        if let mail = emailField.text, !mail.isEmpty,
           let password = passwordField.text, !password.isEmpty{
            CurrentUser.shared = CurrentUser(id: 6, nombre: "Luis", mail: mail, location: "Puerto ordaz, Bolivar, Venezuela")
            performSegue(withIdentifier: "sucessfulLogin", sender: nil)
        }
    }
}
