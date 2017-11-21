//
//  CheckInVC.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/10/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire



class CheckInVC: UIViewController {
    
    @IBOutlet weak var nombreLocacion: UILabel!
    @IBOutlet weak var cordenadas: UILabel!
    @IBOutlet weak var ubicacionCompleta: UILabel!
    @IBOutlet weak var campoComentario: UITextView!

    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var desdelat : CLLocationDegrees = 0.0
    var desdelon : CLLocationDegrees = 0.0
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.distanceFilter = 5.0
        locManager.requestWhenInUseAuthorization()
        self.campoComentario.placeholder = "Escribe un comentario del sitio"
        self.campoComentario.delegate = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.campoComentario.text = ""
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        locManager.requestLocation()
    }

    @IBAction func cancelarBtn(_ sender: Any) {
        if let tab = self.tabBarController as? CustomTabBarController{
            self.tabBarController?.selectedIndex = tab.lastTab
        } else {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func guardarBtn(_ sender: Any) {
        if !id.isEmpty, let user_id = CurrentUser.shared?._id{
            var body:[String: Any] = [:]
            if let comentario = campoComentario.text, !comentario.isEmpty{
                body["comment"] = comentario
            }
            body["tourist_id"] = self.id
            body["poi_id"] = user_id
            
            //let ruta = "emprenomina.com/perfil/API/checkin/"
            let ruta = kRutaSecundaria + "/perfil/API/checkin/"
            
            Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                guard 200...300 ~= (response.response?.statusCode ?? -999)
                    else {
                        UIAlertController.presentViewController(title: "Error", message: "No se pudo hacer Check In en el sitio", view: self)
                        return
                }

                UIAlertController.presentViewController(title: "", message: "¡Felicidades haz hecho Check In al lugar!", view: self)
            }
        }
    }
    
}

extension CheckInVC: CLLocationManagerDelegate{
    
    func consultarApi(latitude: String, longitude: String){
        let body = ["coordenada":[
                        "lat": latitude,
                        "lon": longitude
            ]]
        
        //let ruta = "http://emprenomina.com/base/api/where_am_i/"
        let ruta = kRutaSecundaria + "/base/api/where_am_i/"
        
        Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let result = response.result.value as? [String:Any],
                let name = result["name"] as? String,
                let locality = result["locality"] as? String,
                let locality_id = result["id"] as? Int,
                let lng = result["lng"] as? String,
                let lat = result["lat"] as? String
                else {
                    self.nombreLocacion.text = "Direccion desconocida"
                    self.ubicacionCompleta.text = ""
                    self.id = ""
                    return
            }
            
            self.nombreLocacion.text = name
            self.ubicacionCompleta.text = locality
            self.id = "\(locality_id)"
            self.cordenadas.text = "\(lat), \(lng)"
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            self.cordenadas.text = "\(desdelat), \(desdelon)"
            desdelat = currentLocation.coordinate.latitude
            desdelon = currentLocation.coordinate.longitude
            self.consultarApi(latitude: String(desdelat), longitude: String(desdelon))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error localizacion")
         UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}

extension CheckInVC: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView){
        textView.resignFirstResponder()
    }

}

