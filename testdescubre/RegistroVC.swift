//
//  RegistroVC.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/16/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class RegistroVC: UIViewController {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelarAction(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func registrarAction(_ sender: Any) {
        if let location = location.text, !location.isEmpty,
            let mail = mail.text, !mail.isEmpty,
            let password = password.text, !password.isEmpty,
            let username = username.text, !username.isEmpty{
            CurrentUser.shared = CurrentUser(id: 6, nombre: username, mail: mail, location: location)
            performSegue(withIdentifier: "sucessfulRegister", sender: nil)
        }
    }
    
    
}
