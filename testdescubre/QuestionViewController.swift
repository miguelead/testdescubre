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

struct places {
    var name: String
    var uid: String
    init(name: String, uid: String) {
        self.name = name
        self.uid = uid
    }
}
class QuestionViewController: UIViewController {
    
    @IBOutlet weak var selectMessage: UILabel!
    @IBOutlet weak var endButtom: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var lugares:[places] = []
    var selectedPlace:[places] = []
    var locationActual: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.endButtom.isEnabled = false
        self.consultarApi(lat: locationActual.latitude, long: locationActual.longitude)
    }

    func consultarApi(lat: Double, long: Double){
        lugares = [places(name: "Orinokia", uid: "12"), places(name: "Tomasa", uid: "10"),places(name: "santo tome", uid: "2") ,places(name: "playa el agua", uid: "5") ,places(name: "Plaza el hierro", uid: "11") ,places(name: "Upata", uid: "13")]
        self.tableView.reloadData()
    }
    
    func consultarApi(lugaresSeleccionados: [places]){
        guard let user = CurrentUser.shared else {
            UIAlertController.presentViewController(title: "Error", message: "Existe un problema con su usuario, intentelo mas tarde", view: self, OkLabel: "Aceptar", successEvent: { evento in })
            return
        }
        let ref = Database.database().reference()
        ref.child("users").child(user._id).setValue(["FirstTime": true])
        AppDelegate.getAppDelegate().registerForPushNotifications()
        self.performSegue(withIdentifier: "sucessfulLogin", sender: nil)
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
        consultarApi(lugaresSeleccionados: selectedPlace)
    }
}


extension QuestionViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedPlace.map({$0.name}).index(of: lugares[indexPath.row].name){
            selectedPlace.remove(at: index)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            if selectedPlace.count < 5 {
                self.endButtom.isEnabled = false
            }
        } else {
            self.selectedPlace.append(self.lugares[indexPath.row])
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            if self.selectedPlace.count >= 5 {
                self.endButtom.isEnabled = true
            }
        }
        
        if selectedPlace.count == 0{
            selectMessage.text = "¿Dónde te gustaria ir?\nSelecciona al menos 5 lugares"
        } else if 1...3 ~= selectedPlace.count{
            selectMessage.text = "¿Dónde te gustaria ir?\nSelecciona al menos \((5 - selectedPlace.count)) lugares mas"
        } else if selectedPlace.count == 4{
            selectMessage.text = "¿Dónde te gustaria ir?\nSelecciona al menos 1 lugar mas"
        } else {
            selectMessage.text = "¿Dónde te gustaria ir?\nGracias por seleccionar"
        }
        
    }
}

extension QuestionViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sitioCell", for: indexPath)
        cell.textLabel?.text = lugares[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lugares.count
    }
}
