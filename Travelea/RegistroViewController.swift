//
//  RegistroVC.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/16/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import IQKeyboardManagerSwift
import CoreLocation
import Alamofire

class RegistroViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var repeat_password: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var indicadorView: UIActivityIndicatorView!
    var locationActual: CLLocationCoordinate2D!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.shadowImage = UIImage()
        self.indicadorView.stopAnimating()
    }

    @IBAction func cancelarAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func registrarAction(_ sender: Any) {
        if let mail = mail.text, !mail.isEmpty,
            let password = password.text, !password.isEmpty,
            let username = username.text, !username.isEmpty,
            let repeat_password = repeat_password.text, !repeat_password.isEmpty,
            repeat_password == password{
            self.indicadorView.startAnimating()
            Auth.auth().createUser(withEmail: mail, password: password) { (user, error) in
                guard let user = user, error == nil else {
                    self.indicadorView.stopAnimating()
                    UIAlertController.presentViewController(title: "Error", message: error?.localizedDescription ?? "Hubo un problema al momento de registro, intentelo mas tarde", view: self, OkLabel: "Aceptar", successEvent: { evento in
                    })
                    return
                }
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges { _ in }
                let ref = Database.database().reference()
                var content = ["FirstTime": false,"username": username, "mail": mail, "puntos": 0, "checkIn": 0, "guardados":0] as [String : Any]
                 ref.child("users").child(user.uid).setValue(content)
                CurrentUser.shared = CurrentUser(user: user, customData: ["puntos": 0, "checkIn": 0, "guardados":0])
                let body: [String: Any] = [
                    "email": mail,
                    "username": username,
                    "firebase_token": user.uid,
                    "lat": self.locationActual.latitude,
                    "lng": self.locationActual.longitude]
                self.consultaApi(body: body)
                }
            } else {
                UIAlertController.presentViewController(title: "Error", message: "Existen campos vacios\n Completelos para continuar con el registro", view: self, OkLabel: "Aceptar", successEvent: { evento in })
            }
        }
}


extension RegistroViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension RegistroViewController{
    func consultaApi(body: [String:Any]){
        let ruta = KRutaMain + "/base/api/register/"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            self.indicadorView.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard 200...300 ~= (response.response?.statusCode ?? -999),
                let result = response.result.value as? [String:Any],
                let userId = result["id"] as? Int
                else {
                    UIAlertController.presentViewController(title: "Error", message: "Hubo un problema de conexion, intentelo mas tarde", view: self, OkLabel: "Aceptar", successEvent: { evento in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                        dismiss(animated: true, completion: nil)
                    })
                    return
            }
            CurrentUser.shared?._uid = "\(userId)"
            self.performSegue(withIdentifier: "endRegisterEvent", sender: nil)
        }
    }
    
}




