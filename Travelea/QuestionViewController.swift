//
//  QuestionViewController.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/20/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import Alamofire

struct Places {
    var name: String
    var ubicacion: String
    var tipo: String
    var photo: String
    var uid: String
    var isSelected:Bool = false
    init(name: String, uid: String, ubicacion: String, tipo: String, photo: String) {
        self.name = name
        self.ubicacion = ubicacion
        self.tipo = tipo
        self.photo = photo
        self.uid = uid
    }
}
class QuestionViewController: UIViewController {
    
    @IBOutlet weak var selectMessage: UILabel!
    @IBOutlet weak var endButtom: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var lugares:[Places] = []
    let kminPoi = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        self.endButtom.isEnabled = false
        self.selectMessage.text = "¿Dónde has ido o te gustaría ir?\nSelecciona al menos \(kminPoi) lugares"
        self.consultarApi()
    }

    func consultarApi(){
        let ruta = KRutaMain + "/login/api/minigame/"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(ruta, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard 200...300 ~= (response.response?.statusCode ?? -999),
                let result = response.result.value as? [String:Any],
                let lugaresJson = result["pois"] as? [[String:Any]],
                lugaresJson.count >= self.kminPoi
                else {
                    UIAlertController.presentViewController(title: "Error", message: "Hubo un problema de conexion, intentelo mas tarde", view: self, OkLabel: "Aceptar", successEvent: { evento in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    })
                    CurrentUser.shared = nil
                    return
            }
            self.lugares = lugaresJson.flatMap({ lugar -> Places? in
                if let name = lugar["name"] as? String, let id = lugar["id"] as? Int{
                    return Places(name: name, uid: "\(id)", ubicacion: lugar["address"] as? String ?? "", tipo: lugar["get_descriptor_concat"] as? String ?? "", photo: lugar["photo"] as? String ?? "")
                }
                return nil
            })
            self.tableView.reloadData()
        }
    }
    
    func consultarApi(lugaresSeleccionados: [Places]){
        guard let user = CurrentUser.shared else {
            UIAlertController.presentViewController(title: "Error", message: "Existe un problema con su usuario, intentelo mas tarde", view: self, OkLabel: "Aceptar", successEvent: { evento in })
            return
        }
        let ruta = KRutaMain + "/login/api/minigame/"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let selectData: [[String:String]] = lugaresSeleccionados.flatMap { place -> [String: String] in
            return ["id": place.uid]
        }
        let body: [String:Any] = ["tourist_id": user._uid, "pois" : selectData]
        Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard 200...300 ~= (response.response?.statusCode ?? -999)
                else {
                    UIAlertController.presentViewController(title: "Error", message: "Hubo un problema de conexion, intentelo mas tarde", view: self, OkLabel: "Aceptar", successEvent: { evento in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    })
                    CurrentUser.shared = nil
                    return
            }
         
            let ref = Database.database().reference()
            ref.child("users/\(user._id)/FirstTime").setValue(true)
            AppDelegate.getAppDelegate().registerForPushNotifications()
            AppDelegate.getAppDelegate().setBackgroundManagerLocation()
            self.performSegue(withIdentifier: "sucessfulLogin", sender: nil)
        }
    }

    
    @IBAction func cancelarEvento(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
    @IBAction func siguienteEvento(_ sender: Any) {
        consultarApi(lugaresSeleccionados: lugares.filter({$0.isSelected}))
    }
}


extension QuestionViewController: UITableViewDelegate{
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath as IndexPath) != nil {
            self.lugares[indexPath.row].isSelected = !self.lugares[indexPath.row].isSelected
            if self.lugares.filter({$0.isSelected}).count >= kminPoi {
                self.endButtom.isEnabled = true
            } else {
                self.endButtom.isEnabled = false
            }
            if lugares.filter({$0.isSelected}).count == 0{
                selectMessage.text = "¿Dónde has ido o te gustaría ir?\nSelecciona al menos \(kminPoi) lugares"
            } else if 1...kminPoi-2 ~= lugares.filter({$0.isSelected}).count{
                selectMessage.text = "¿Dónde has ido o te gustaría ir?\nSelecciona al menos \((kminPoi - lugares.filter({$0.isSelected}).count)) lugares mas"
            } else if lugares.filter({$0.isSelected}).count == kminPoi-1{
                selectMessage.text = "¿Dónde has ido o te gustaría ir?\nSelecciona al menos 1 lugar mas"
            } else {
                selectMessage.text = "¿Dónde has ido o te gustaría ir?\nGracias por seleccionar"
            }
            self.tableView.reloadData()
        }
    }
}

extension QuestionViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sitioCell", for: indexPath) as! puntoInteresCheck
        cell.configureCell(lugares[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lugares.count
    }
}
