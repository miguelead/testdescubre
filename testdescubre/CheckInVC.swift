//
//  CheckInVC.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/10/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import CoreLocation



class CheckInVC: UIViewController {

    
   
    @IBOutlet weak var nombreLocacion: UILabel!
    @IBOutlet weak var cordenadas: UILabel!
    @IBOutlet weak var ubicacionCompleta: UILabel!
    @IBOutlet weak var campoComentario: UITextView!

    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var desdelat : CLLocationDegrees = 0.0
    var desdelon : CLLocationDegrees = 0.0
    var ubicacionTexto = "Sitio no encontrado"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(CheckInVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CheckInVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.distanceFilter = 5.0
        locManager.requestWhenInUseAuthorization()
        self.campoComentario.placeholder = "Escribe un comentario del sitio"
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.campoComentario.text = ""
        locManager.requestLocation()
    }

    @IBAction func cancelarBtn(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func guardarBtn(_ sender: Any) {
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
}

extension CheckInVC: CLLocationManagerDelegate{
    
    func getAddressForLatLng(latitude: String, longitude: String) -> (completeName:String, title: String){
        let url = NSURL(string: "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(apikey)")
        let data = NSData(contentsOf: url! as URL)
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        if let result = json["results"] as? [[String : Any]],
           let address = result[0]["formatted_address"] as? String{
            return (address, address)
        }else {
            return ("","Direccion desconocida")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            self.cordenadas.text = "\(desdelat), \(desdelon)"
            desdelat = currentLocation.coordinate.latitude
            desdelon = currentLocation.coordinate.longitude
            let direccion = getAddressForLatLng(latitude: String(desdelat), longitude: String(desdelon))
            self.nombreLocacion.text = direccion.title
            self.ubicacionCompleta.text = direccion.completeName
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error localizacion")
    }

}
