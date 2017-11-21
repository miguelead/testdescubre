//
//  LoginViewController.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/15/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FBSDKLoginKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var locManager = CLLocationManager()
    var locationActual: CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude: 8.2972945, longitude: -62.7114469)
    var tokenFacebook: String?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.loadingView.stopAnimating()
        self.obtenerLocalizacionActual()
    }

    @IBAction func registrarEvento(_ sender: Any) {
        performSegue(withIdentifier: "RegisterEvent", sender: nil)
    }
    
    @IBAction func continuarConFacebook(_ sender: Any) {
        if FacebookLoginService.userIsFacebookLoggedIn(){
            self.loadingView.startAnimating()
            self.firebaseUpdateFacebook()
        } else {
            self.loadingView.startAnimating()
            FacebookLoginService.getFacebookPermission(from: self, permissionEvent: { [weak self] permission in
                switch permission{
                case .allPermission:
                    self?.firebaseUpdateFacebook()
                    break
                }
                }, PermissionError: { [weak self] error in
                    switch error{
                    case .cancel:
                        self?.loadingView.stopAnimating()
                        break
                    case .ErrorConexion:
                        self?.loadingView.stopAnimating()
                        self?.errorEvent()
                        break
                    }
            })
        }
    }
    
    func obtenerLocalizacionActual(){
        locManager.delegate = self
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.requestLocation()
    }
    
    func firebaseUpdateFacebook(){
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (users, error) in
            guard error == nil,
                let user = users,
                let mail = user.email else {
                self.loadingView.stopAnimating()
                self.errorEvent(mensaje: error?.localizedDescription ?? "Hubo un problema de conexion, intentelo mas tarde")
                    return
            }
            let ref = Database.database().reference()
            ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
                 var customData: [String:Any] = [:]
                let value = snapshot.value as? NSDictionary
                if let name = value?["name"]{
                    customData["name"] = name
                }
                CurrentUser.shared = CurrentUser(user: user, customData: customData)
                if value?["FirstTime"] == nil{
                    ref.child("users").child(user.uid).setValue(["name": user.displayName ?? "", "FirstTime": false])
                }
                let body: [String: Any] = [
                    "email": mail,
                    "username": user.displayName ?? "",
                    "firebase_token": user.uid,
                    "lat": self.locationActual.latitude,
                    "lng": self.locationActual.longitude]
                
                self.consultaApi(body: body, value: value)
            }) { (error) in
                self.loadingView.stopAnimating()
                self.errorEvent()
            }
        }
    }
    
    func errorEvent(mensaje: String = "Hubo un problema de conexion, intentelo mas tarde"){
        UIAlertController.presentViewController(title: "Error", message: mensaje, view: self, OkLabel: "Aceptar", successEvent: { evento in })
    }
    
    @IBAction func loginUser(_ sender: Any) {
        if let mail = emailField.text, !mail.isEmpty,
           let password = passwordField.text, !password.isEmpty{
            self.loadingView.startAnimating()
            Auth.auth().signIn(withEmail: mail, password: password) { (user, error) in
                guard error == nil,
                     let user = user else {
                        self.loadingView.stopAnimating()
                    UIAlertController.presentViewController(title: "Error", message: "Usted no se encuentra logeado", view: self, OkLabel: "Aceptar", successEvent: { evento in })
                    return
                }
                
                let ref = Database.database().reference()
                ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
                    var customData: [String:Any] = [:]
                    let value = snapshot.value as? NSDictionary
                    if let name = value?["name"]{
                        customData["name"] = name
                    }
                    CurrentUser.shared = CurrentUser(user: user, customData: customData)
                    let body: [String: Any] = [
                        "email": mail,
                        "username": user.displayName ?? customData["name"] ?? "",
                        "firebase_token": user.uid,
                        "lat": self.locationActual.latitude,
                        "lng": self.locationActual.longitude]
                    self.consultaApi(body: body , value: value)
                }) { (error) in
                    self.errorEvent()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "facebookEndRegister",
            let vc = segue.destination as? QuestionViewController{
            vc.locationActual = locationActual
        } else if segue.identifier == "RegisterEvent",
                let vc = segue.destination as? RegistroViewController,
                let location = locationActual{
            vc.locationActual = location
        }
    }
}

extension LoginViewController{
    func consultaApi(body: [String:Any], value: NSDictionary? = nil){
        let ruta = kRutaSecundaria + "/base/api/register/"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard 200...300 ~= (response.response?.statusCode ?? -999),
                let result = response.result.value as? [String:Any],
                    let userId = result["id"] as? Int
                else {
                    self.loadingView.stopAnimating()
                    UIAlertController.presentViewController(title: "Error", message: "Hubo un problema de conexion, intentelo mas tarde", view: self, OkLabel: "Aceptar", successEvent: { evento in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    })
                    return
            }
            CurrentUser.shared?._uid = "\(userId)"
            self.loadingView.stopAnimating()
            if let firstTime = value?["FirstTime"] as? Bool, firstTime{
                AppDelegate.getAppDelegate().registerForPushNotifications()
                self.performSegue(withIdentifier: "sucessfulLogin", sender: nil)
            } else {
                self.performSegue(withIdentifier: "facebookEndRegister", sender: nil)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last{
            locationActual = last.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error localizacion")
    }
}
