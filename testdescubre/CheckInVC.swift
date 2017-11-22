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
    @IBOutlet weak var botonGuardar: UIBarButtonItem!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var desdelat : CLLocationDegrees = 0.0
    var desdelon : CLLocationDegrees = 0.0
    var PlaceId = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.distanceFilter = 5.0
        locManager.requestWhenInUseAuthorization()
        self.campoComentario.placeholder = "Escribe un comentario del sitio"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.botonGuardar.isEnabled = false
        self.loading.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.campoComentario.text = ""
        self.nombreLocacion.text = "----"
        self.ubicacionCompleta.text = ""
        self.cordenadas.text = "0.0,0.0"
        self.PlaceId = ""
        self.botonGuardar.isEnabled = false
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
        if !PlaceId.isEmpty, let user_id = CurrentUser.shared?._uid{
            var body:[String: Any] = [:]
            if let comentario = campoComentario.text, !comentario.isEmpty{
                body["comment"] = comentario
            }
            body["tourist_id"] = user_id
            body["poi_id"] = self.PlaceId
            let ruta = KRutaMain + "/perfil/API/checkin/"
            self.loading.startAnimating()
            Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                self.loading.stopAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                guard 200...300 ~= (response.response?.statusCode ?? -999)
                    else {
                        UIAlertController.presentViewController(title: "Error", message: "No se pudo hacer Check In en el sitio", view: self)
                        return
                }

                UIAlertController.presentViewController(title: "", message: "¡Felicidades haz hecho Check In al lugar!", view: self, successEvent: {_ in
                    if let tab = self.tabBarController as? CustomTabBarController{
                        self.tabBarController?.selectedIndex = tab.lastTab
                    } else {
                        self.tabBarController?.selectedIndex = 0
                    }
                })
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
        
        let ruta = KRutaMain + "/base/api/where_am_i/"
        
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
                    self.PlaceId = ""
                    return
            }
            
            self.nombreLocacion.text = name
            self.ubicacionCompleta.text = locality
            self.PlaceId = "\(locality_id)"
            self.cordenadas.text = "\(lat), \(lng)"
            self.botonGuardar.isEnabled = true
            
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


