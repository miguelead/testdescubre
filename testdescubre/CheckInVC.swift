//
//  CheckInVC.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/10/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import CoreLocation



class CheckInVC: UIViewController, CLLocationManagerDelegate {

    
    @IBAction func cancelarBtn(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 0
        
    }
    
    @IBAction func guardarBtn(_ sender: Any) {
    }
    
    /*

     Pasos para hacer check-in
     
 
    */
    
    
    // Obtener locacion

    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var desdelat : CLLocationDegrees = 0.0
    var desdelon : CLLocationDegrees = 0.0
    var ubicacionTexto = "null"
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyDiMXRRlAI8s5_vzRZknBiDUuukquzFWNI"
    
    
    func getAddressForLatLng(latitude: String, longitude: String) -> String{
        let url = NSURL(string: "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(apikey)")
        let data = NSData(contentsOf: url! as URL)
        
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        if let result = json["results"] as? [[String : Any]] {
            
            let address = result[0]["formatted_address"] as? String
            
            return (address!)
            
            
//            if let address = result[0]["address_components"] as? [[String : Any]] {
//        
//                let number = address[0]["short_name"] as! String
//                let street = address[1]["short_name"] as! String
//                let city = address[2]["short_name"] as! String
//                let state = address[4]["short_name"] as! String
//                let zip = address[6]["short_name"] as! String
//                print("\n\(number) \(street), \(city), \(state) \(zip)")
//            }
            
            
        }else {
            return ("Direccion desconocida")
        
        }
    }
    
    
    
    // View Lifecycle
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
    
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locManager.location

            desdelat = currentLocation.coordinate.latitude
           
            desdelon = currentLocation.coordinate.longitude
            
            let desdelatTxt = String(desdelat)
            let desdelonTxt = String(desdelon)
            
            print(getAddressForLatLng(latitude: desdelatTxt, longitude: desdelonTxt))
            
            

            
            
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        // Obtener locacion
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.distanceFilter = 5.0
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
