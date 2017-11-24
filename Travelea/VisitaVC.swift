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

class VisitaVC: UIViewController{
 
    @IBOutlet weak var filtrosLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var ActualRequest: Int?
    var listapuntodeinteres = [PuntoDeInteres]()
    var locManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
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
        self.filtrosLabel.text = ""
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
        obtenerLocalizacionActual()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    func obtenerLocalizacionActual(){
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.requestLocation()
    
    }
    
    func consultaApi(){
        
        guard let desdelatParam = filtroSeleccionado["desdelat"] as? Double,
             let desdelonParam = filtroSeleccionado["desdelon"] as? Double,
             let ordenarPor = filtroSeleccionado["ordenarpor"] as? Int,
             let filtrarPor = filtroSeleccionado["filtrarpor"] as? Int,
             let hastakmParam = filtroSeleccionado["hastakm"] as? Int,
             let user = CurrentUser.shared else {
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
        if filtrarPor == 1 {filtrarporParam = "Comer"}
        if filtrarPor == 2 {filtrarporParam = "Ver"}
        if filtrarPor == 3 {filtrarporParam = "Dormir"}
        if filtrarPor == 4 {filtrarporParam = "Servicios"}

        var ruta = KRutaMain + ":8001/api/search?"
        ruta += "query=" + filtrarporParam
        ruta += "&lat=\(desdelatParam)"
        ruta += "&lng=\(desdelonParam)"
        ruta += "&qtime=\(NSDate().timeIntervalSince1970)"
        ruta += "&sort_by=\(ordenarporParam)"
        ruta += "&discover=0"
        ruta += "&limit=\(kLimitPag)"
        ruta += "&offset=\(self.listapuntodeinteres.count)"
        ruta += "&user_id=\(user._uid)"
        ruta += "&radius=\(hastakmParam)"
        

        Alamofire.request(ruta, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.refreshControl.endRefreshing()
            guard let result = response.result.value as? [String:Any],
                 let response = result["response"] as? [String:Any],
                 let meta = result["meta"] as? [String:Any],
                 let RequestId = meta["requestID"] as? Int,
                 let listElement = response["items"] as? [[String:Any]]
            else {
                if self.listapuntodeinteres.isEmpty{
                   self.addBackgroundImage()
                } else {
                    self.tableView.backgroundView = nil
                }
                return
            }
            self.ActualRequest = RequestId
            self.listapuntodeinteres.removeAll()
            for elemento in listElement {
                if let POIId = elemento["id"] as? Int, let titulo = elemento["name"] as? String,
                let recom_index = elemento["rating"] as? Float, let categoria = elemento["category"] as? String,
                let direccion = elemento["address"] as? String, let precio = elemento["price"] as? String,
                let lat = elemento["lat"] as? String, let lon = elemento["lng"] as? String,
                let photo = elemento["photo"] as? String{
                    let POItemporal = PuntoDeInteres(POIId: POIId, titulo: titulo, categoria: categoria, direccion: direccion, lat : lat, lon : lon, precio: precio, recom_index : recom_index, photo: photo)
                    self.listapuntodeinteres.append(POItemporal)
                }
            }
            if self.listapuntodeinteres.isEmpty{
                self.addBackgroundImage()
            } else {
                self.filtrosLabel.text = "Lugares para " + filtrarporParam + " ordenado por " + ordenarporParam
                self.tableView.backgroundView = nil
            }
            self.tableView.reloadData()
        }
    
    }
    
    func addBackgroundImage(){
        let image = #imageLiteral(resourceName: "emptystate-12").withRenderingMode(.alwaysTemplate) 
        let topMessage = "Descubre Nuevos Sitios"
        let bottomMessage = "Haz pull para consultar de nuevo"
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        tableView.backgroundView = emptyBackgroundView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarPuntoDeInteresDetalleCV",
           let vc = segue.destination as? PuntoDeInteresDetalleVC,
           let cell = sender as? PuntodeinteresCell{
            vc.punto = cell.puntodeinteres
            vc.distanciaActual = currentLocation ?? CLLocationCoordinate2D(latitude: (filtroSeleccionado["desdelat"] as? Double) ?? 0.0, longitude: (filtroSeleccionado["desdelon"] as? Double) ?? 0.0)
        }
    }
    
}

extension VisitaVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last{
            filtroSeleccionado["desdelat"] = last.coordinate.latitude
            filtroSeleccionado["desdelon"] = last.coordinate.longitude
            currentLocation = last.coordinate
            consultaApi()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error localizacion")
        self.refreshControl.endRefreshing()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension VisitaVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! PuntodeinteresCell
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

extension VisitaVC: DescubreFilterVC{
    func parseFilter(filter: [String:Any]){
        self.filtroSeleccionado = filter
        consultaApi()
    }
}

