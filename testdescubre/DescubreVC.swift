//
//  ViewController.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 5/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class DescubreVC: UIViewController, GuardarFiltrarDelegate{
 
    @IBOutlet weak var tableView: UITableView!
    
    var filtroelegido = 1
    var listapuntodeinteres = [PuntoDeInteres]()
    var filteredlistapuntodeinteres = [PuntoDeInteres]()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.hexStringToUIColor(hex: "11A791")
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        obtenerLocalizacionActual()
    }
    
    var filtroSeleccionado : [String:Any] = [
        "mapa": false,
        "desdelat": 0.0,
        "desdelon": 0.0,
        "hastakm": 1,
        "ordenarpor": 1,
        "filtrarpor": 1
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
        obtenerLocalizacionActual()
    }
    
    
    func obtenerLocalizacionActual(){
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.requestLocation()
    
    }
    func guardarFiltrar(data: [String:Any]) {
        filtroSeleccionado = data
        consultaApi()
    }
      
    func consultaApi(){
        
        guard let desdelatParam = filtroSeleccionado["desdelat"] as? Double,
             let desdelonParam = filtroSeleccionado["desdelon"] as? Double,
             let ordenarPor = filtroSeleccionado["ordenarpor"] as? Int,
             let filtrarPor = filtroSeleccionado["filtrarpor"] as? Int,
             let hastakmParam = filtroSeleccionado["hastakm"] as? Int else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.refreshControl.endRefreshing()
                return
        }
        
        var ordenarporParam : String = ""
        if  ordenarPor == 1 {ordenarporParam = "Rating" }
        if  ordenarPor == 2 {ordenarporParam = "Distancia"}
        if  ordenarPor == 3 {ordenarporParam = "Precio"}
        if  ordenarPor == 4 {ordenarporParam = "Popularidad"}
        
        var filtrarporParam : String = ""
        if filtrarPor == 1 {filtrarporParam = "Ver"}
        if filtrarPor == 2 {filtrarporParam = "Comer"}
        if filtrarPor == 3 {filtrarporParam = "Dormir"}
        if filtrarPor == 4 {filtrarporParam = "Servicios"}

        let ruta = "http://emprenomina.com/recomendacion/concepto/"
        let param: [String: Any] = [
            "usuarioActivo": "6",
            "coordenada": [
                "lat": "\(desdelatParam)",
                "lon": "\(desdelonParam)"
            ],
            "kmAlrededor": "\(hastakmParam)",
            "clima" : "",
            "ciudad": "",
            "hora": "",
            "conceptos": [""],
            "caracteristicas": [""],
            "N": NUMBER_LIST,
            "ordenamiento": ordenarporParam,
            "sitios": [],
            "descubre":"0",
            "auto" : "0"
            //"query": filtrarporParam
        ]
        
        // cambiar endpoint por esto
        //user_id
        //query -filtrarpOR
        //lat
        //lng
        //wheater
        //qtime
        //sort_by
        //discover
        //radius
        //limit
        //offset
        
        
        Alamofire.request(ruta, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print(response)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.refreshControl.endRefreshing()
            guard let result = response.result.value as? [[String:Any]] else {
                return
            }
            let tipo = "test"
            let lat = "test"
            let lon = "test"
            self.listapuntodeinteres.removeAll()
            for elemento in result {
                if let POIId = elemento["id"] as? Int, let titulo = elemento["titulo"] as? String,
                let recom_index = elemento["valor"] as? Float, let categoria = elemento["categoria"] as? String,
                let direccion = elemento["direccion"] as? String, let precio = elemento["precio"] as? String{
                    let POItemporal = PuntoDeInteres(POIId: POIId, titulo: titulo, tipo: tipo, categoria: categoria, direccion: direccion, lat : lat, lon : lon, precio: precio, recom_index : recom_index)
                    self.listapuntodeinteres.append(POItemporal)
                }
            }
            self.tableView.reloadData()
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarFiltrarVC"{
            let FiltrarVC : FiltrarVC = segue.destination as! FiltrarVC
            FiltrarVC.delegate = self
            FiltrarVC.filtroSeleccionado = filtroSeleccionado
        }
        
        if segue.identifier == "mostrarPuntoDeInteresDetalleCV"{
        }
    }
    
}

extension DescubreVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last{
            filtroSeleccionado["desdelat"] = last.coordinate.latitude
            filtroSeleccionado["desdelon"] = last.coordinate.longitude
            consultaApi()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error localizacion")
        self.refreshControl.endRefreshing()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension DescubreVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! puntodeinteresCell
        let puntos = listapuntodeinteres[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(puntos, lat: (filtroSeleccionado["desdelat"] as? Double) ?? 0.0,lon: (filtroSeleccionado["desdelon"] as? Double) ?? 0.0)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listapuntodeinteres.count
    }
}

