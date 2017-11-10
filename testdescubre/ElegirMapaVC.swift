//
//  ElegirMapaVC.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 29/10/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


protocol ConfirmarElegirCiudadDelegate {
    func confirmarElegirCiudad(data: [String:Any])
    
}


class ElegirMapaVC: UIViewController, CLLocationManagerDelegate {

    var delegate : ConfirmarElegirCiudadDelegate? = nil
    
    @IBOutlet weak var ciudadLbl: UILabel!
    @IBOutlet weak var ciudadcoordenadasLbl: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    //    Obtener locacion
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var filtroSeleccionado : [String:Any] = [
        "hubocambio" : false,
        "mapa": false,
        "desdelat": 0.0,
        "desdelon": 0.0,
        "hastakm": 1,
        "ordenarpor": 1,
        "filtrarpor": 1
    ]
  
    @IBAction func confirmarBtn(_ sender: UIBarButtonItem) {
        
        if delegate != nil {
            
            delegate?.confirmarElegirCiudad(data: filtroSeleccionado)
            print (filtroSeleccionado)
            
            self.navigationController?.popViewController(animated: true)
            
            
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(filtroSeleccionado)
        
//      Cargar pin en el lugar donde dice el diccionario
        
        
        
        
//        
//        locManager.delegate = self
//        locManager.desiredAccuracy = kCLLocationAccuracyBest
//        locManager.requestWhenInUseAuthorization()
//        locManager.startUpdatingLocation()
//        
        
        
        let latitude : CLLocationDegrees = filtroSeleccionado["desdelat"] as! Double
        let longitude : CLLocationDegrees = filtroSeleccionado["desdelon"] as! Double
        
        
//        var latitude : CLLocationDegrees = 10
//        var longitude : CLLocationDegrees = 10
//        
//        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//            
//            currentLocation = locManager.location
//            
//            latitude  = currentLocation.coordinate.latitude
//            longitude = currentLocation.coordinate.longitude
//            
//        }
//        
        
        
       
        let latDelta : CLLocationDegrees = 0.05
        let lonDelta : CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let location = CLLocation(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let puntoSeleccionado = MKPointAnnotation()
        puntoSeleccionado.coordinate = coordinates
        
        
        puntoSeleccionado.title = ""
        puntoSeleccionado.subtitle = ""
        
        mapView.addAnnotation(puntoSeleccionado)
        mapView.selectAnnotation(puntoSeleccionado, animated: true)

        ciudadLbl.text = "\(puntoSeleccionado.coordinate.latitude),\(puntoSeleccionado.coordinate.longitude)"
        
        
        mapView.isUserInteractionEnabled = true
        
        
        let UIlgpr = UILongPressGestureRecognizer(target: self, action: #selector(cambiarSitiolongpress(gestureRecognizer:)))
        
        UIlgpr.minimumPressDuration = 2
        
        mapView.addGestureRecognizer(UIlgpr)
        
        
//        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
//            print(location)
//            
//            if error != nil {
//                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
//                return
//            }
//            
//            if (placemarks?.count)! > 0 {
//                let pm = placemarks?[0]
//                print("Ciudad: \(String(describing: pm?.locality)) y calle: \(String(describing: pm?.thoroughfare)) ")
//             
//            }
//            else {
//                print("Problem with the data received from geocoder")
//            }
//        })
        
    
     }
    
    func cambiarSitiolongpress(gestureRecognizer: UILongPressGestureRecognizer){
        
        let touchpoint = gestureRecognizer.location(in: mapView)
        
        let coordinate = mapView.convert(touchpoint, toCoordinateFrom: mapView)

        let puntoSeleccionado = MKPointAnnotation()
        
        puntoSeleccionado.coordinate = coordinate

        puntoSeleccionado.title = "Nuevo lugar"
//        annotation.subtitle = "Nuevo lugar - sub"
        
        
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        
        mapView.addAnnotation(puntoSeleccionado)
        mapView.selectAnnotation(puntoSeleccionado, animated: true)

        filtroSeleccionado["desdelat"] = puntoSeleccionado.coordinate.latitude
        filtroSeleccionado["desdelon"] = puntoSeleccionado.coordinate.longitude
        
        ciudadLbl.text = "\(puntoSeleccionado.coordinate.latitude),\(puntoSeleccionado.coordinate.longitude)"
     
    }
 
 
}
