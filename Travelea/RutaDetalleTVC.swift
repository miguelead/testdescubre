//
//  RutaDetalleTVC.swift
//  Travelea
//
//  Created by Momentum Lab 2 on 11/27/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import UIKit

class RutaDetalleTVC: UITableViewController {
    
    var autorruta: AutorRutaDeInteresDetalle!
    var listaderutas: RutaDeInteresDetalle!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
 

}


////
////  ElegirMapaVC.swift
////  testdescubre
////
////  Created by Miguel Alvarez on 29/10/17.
////  Copyright © 2017 Miguel Alvarez. All rights reserved.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//
//
//protocol ConfirmarElegirCiudadDelegate {
//    func confirmarElegirCiudad(data: [String:Any])
//    
//}
//
//
//class ElegirMapaVC: UIViewController, CLLocationManagerDelegate {
//    
//    var delegate : ConfirmarElegirCiudadDelegate? = nil
//    
//    @IBOutlet weak var ciudadLbl: UILabel!
//    @IBOutlet weak var ciudadcoordenadasLbl: UILabel!
//    
//    @IBOutlet weak var mapView: MKMapView!
//    
//    //    Obtener locacion
//    var locManager = CLLocationManager()
//    var currentLocation: CLLocation!
//    
//    var filtroSeleccionado : [String:Any] = [
//        "hubocambio" : false,
//        "mapa": false,
//        "desdelat": 0.0,
//        "desdelon": 0.0,
//        "hastakm": 1,
//        "ordenarpor": 1,
//        "filtrarpor": 1
//    ]
//    
//    @IBAction func confirmarBtn(_ sender: UIBarButtonItem) {
//        
//        if delegate != nil {
//            delegate?.confirmarElegirCiudad(data: filtroSeleccionado)
//            _ = self.navigationController?.popViewController(animated: true)
//        }
//        
//        
//    }
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        let latitude : CLLocationDegrees = filtroSeleccionado["desdelat"] as! Double
//        let longitude : CLLocationDegrees = filtroSeleccionado["desdelon"] as! Double
//        
//        let latDelta : CLLocationDegrees = 0.05
//        let lonDelta : CLLocationDegrees = 0.05
//        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
//        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let region = MKCoordinateRegion(center: coordinates, span: span)
//        mapView.setRegion(region, animated: true)
//        
//        let puntoSeleccionado = MKPointAnnotation()
//        puntoSeleccionado.coordinate = coordinates
//        puntoSeleccionado.title = ""
//        puntoSeleccionado.subtitle = ""
//        
//        mapView.addAnnotation(puntoSeleccionado)
//        mapView.selectAnnotation(puntoSeleccionado, animated: true)
//        ciudadLbl.text = "\(puntoSeleccionado.coordinate.latitude),\(puntoSeleccionado.coordinate.longitude)"
//        mapView.isUserInteractionEnabled = true
//        
//        
//        let UIlgpr = UILongPressGestureRecognizer(target: self, action: #selector(cambiarSitiolongpress(gestureRecognizer:)))
//        UIlgpr.minimumPressDuration = 2
//        mapView.addGestureRecognizer(UIlgpr)
//        
//        
//    }
//    
//    func cambiarSitiolongpress(gestureRecognizer: UILongPressGestureRecognizer){
//        let touchpoint = gestureRecognizer.location(in: mapView)
//        let coordinate = mapView.convert(touchpoint, toCoordinateFrom: mapView)
//        let puntoSeleccionado = MKPointAnnotation()
//        puntoSeleccionado.coordinate = coordinate
//        puntoSeleccionado.title = "Nuevo lugar"
//        let allAnnotations = mapView.annotations
//        mapView.removeAnnotations(allAnnotations)
//        mapView.addAnnotation(puntoSeleccionado)
//        mapView.selectAnnotation(puntoSeleccionado, animated: true)
//        filtroSeleccionado["desdelat"] = puntoSeleccionado.coordinate.latitude
//        filtroSeleccionado["desdelon"] = puntoSeleccionado.coordinate.longitude
//        
//        ciudadLbl.text = "\(puntoSeleccionado.coordinate.latitude),\(puntoSeleccionado.coordinate.longitude)"
//        
//    }
//    
//    
//}



//class BuzonPerfilTVC: UITableViewController {
//    
//    var filtroSeleccionado : [String:Any] = [
//        "mapa": false,
//        "desdelat": 0.0,
//        "desdelon": 0.0,
//        "hastakm": 1,
//        "ordenarpor": 1,
//        "filtrarpor": 1
//    ]
//    
//    var listaobjetos:[Any] = []
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        listaobjetos.append(PuntoDeInteres.init(POIId: 1, titulo:"test", categoria: "test", direccion: "test", lat: "test", lon: "test", precio: "test", recom_index: 1, photo: "test"))
//        
//        listaobjetos.append(Ofertas.init(id: 2, idEmpresa: 3, empresa: "test", titulo: "test", categoria: "test", fechaInicial: "test", fechaFinal: "test", tipo: "test", descripcion: "test", photo: "test"))
//        
//        listaobjetos.append(Eventos.init(id: 4, idEmpresa: 3, empresa: "test", titulo: "test", categoria: "test", fechaInicial: "test", fechaFinal: "test", tipo: "test", descripcion: "test", photo: "test"))
//        
//        listaobjetos.append(PuntoDeInteres.init(POIId: 1, titulo:"test", categoria: "test", direccion: "test", lat: "test", lon: "test", precio: "test", recom_index: 1, photo: "test"))
//        
//        listaobjetos.append(PuntoDeInteres.init(POIId: 1, titulo:"test", categoria: "test", direccion: "test", lat: "test", lon: "test", precio: "test", recom_index: 1, photo: "test"))
//        
//        listaobjetos.append(PuntoDeInteres.init(POIId: 1, titulo:"test", categoria: "test", direccion: "test", lat: "test", lon: "test", precio: "test", recom_index: 1, photo: "test"))
//        
//        listaobjetos.append(PuntoDeInteres.init(POIId: 1, titulo:"test", categoria: "test", direccion: "test", lat: "test", lon: "test", precio: "test", recom_index: 1, photo: "test"))
//        
//        
//        
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if let elemento = listaobjetos[indexPath.row] as? PuntoDeInteres{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! PuntodeinteresCell
//            cell.selectionStyle = .none
//            cell.configureCell(elemento, lat: (filtroSeleccionado["desdelat"] as? Double) ?? 0.0,lon: (filtroSeleccionado["desdelon"] as? Double) ?? 0.0)
//            return cell
//            
//            
//        }
//        
//        if let elemento = listaobjetos[indexPath.row] as? Ofertas{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ofertasCell", for: indexPath) as! OfertasCell
//            cell.selectionStyle = .none
//            cell.configureCell(elemento, lat: (filtroSeleccionado["desdelat"] as? Double) ?? 0.0,lon: (filtroSeleccionado["desdelon"] as? Double) ?? 0.0)
//            return cell
//            
//            
//        }
//        
//        if let elemento = listaobjetos[indexPath.row] as? Eventos{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ofertasCell", for: indexPath) as! OfertasCell
//            cell.selectionStyle = .none
//            cell.configureCell(elemento, lat: (filtroSeleccionado["desdelat"] as? Double) ?? 0.0,lon: (filtroSeleccionado["desdelon"] as? Double) ?? 0.0)
//            return cell
//            
//            
//        }
//        return UITableViewCell()
//        
//        
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return listaobjetos.count
//    }
//    
//    
//}
