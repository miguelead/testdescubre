//
//  EventosViewController.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/15/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire
import CoreLocation

class EventosVC: UIViewController {

    var delegate: DescubreFilterVC?
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    var listaEventos = [Eventos]()
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
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
        calendar.appearance.headerTitleFont = UIFont.init(name: "Avenir-Heavy", size: 15)
        calendar.appearance.titleFont = UIFont.init(name: "Avenir-Medium", size: 13)
        calendar.appearance.subtitleFont = UIFont.init(name: "Avenir-Medium", size: 13)
        calendar.appearance.weekdayFont = UIFont.init(name: "Avenir-Medium", size: 13)
        self.calendar.locale = Locale(identifier: "es")
        obtenerLocalizacionActual()
    }

    func obtenerLocalizacionActual(){
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.requestLocation()
    }
    
    func consultaApi(){
        self.refreshControl.endRefreshing()
//        guard
//            let ordenarPor = filtroSeleccionado["ordenarpor"] as? Int,
//            let filtrarPor = filtroSeleccionado["filtrarpor"] as? Int
//            else {
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                self.refreshControl.endRefreshing()
//                return
//        }
        
//        var ordenarporParam : String = ""
//        if  ordenarPor == 1 {ordenarporParam = "Rating" }
//        if  ordenarPor == 2 {ordenarporParam = "Distancia"}
//        if  ordenarPor == 3 {ordenarporParam = "Precio"}
//        if  ordenarPor == 4 {ordenarporParam = "Popularidad"}
//        
//        var filtrarporParam : String = ""
//        if filtrarPor == 1 {filtrarporParam = "Ver"}
//        if filtrarPor == 2 {filtrarporParam = "Comer"}
//        if filtrarPor == 3 {filtrarporParam = "Dormir"}
//        if filtrarPor == 4 {filtrarporParam = "Servicios"}
        
        
        let ruta = KRutaMain + "/base/api/event/"
        
        Alamofire.request(ruta, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.refreshControl.endRefreshing()
            
            guard let result = response.result.value as? [[String:Any]]
                else {
                    return
            }
            
            self.listaEventos.removeAll()
            
            for elemento in result {
                if  let id = elemento["id"] as? Int,
                    let titulo = elemento["name"] as? String,
                    let empresa = elemento["place"] as? [String:Any],
                    let empresa_nombre = empresa["name"] as? String,
                    let categoria = elemento["category"] as? String,
                    let fechaInicial = elemento["begin_date"] as? String,
                    let fechaFinal = elemento["end_date"] as? String,
                    let tipo = elemento["type"] as? String,
                    let descripcion = elemento["description"] as? String{
                    let temporal = Eventos.init(id: id, idEmpresa: 1, empresa: empresa_nombre, titulo: titulo, categoria: categoria, fechaInicial: fechaInicial, fechaFinal: fechaFinal, tipo: tipo, descripcion: descripcion, photo: elemento["photo"] as? String ?? "")
                    self.listaEventos.append(temporal)
                }
            }
            self.tableView.reloadData()
        }
    }

    
}

extension EventosVC: DescubreFilterVC{
    func parseFilter(filter: [String:Any]){
        self.filtroSeleccionado = filter
    }
}

extension EventosVC: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        obtenerLocalizacionActual()
    }
    
}

extension EventosVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last{
            filtroSeleccionado["desdelat"] = last.coordinate.latitude
            filtroSeleccionado["desdelon"] = last.coordinate.longitude
            consultaApi()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error localizacion")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}



extension EventosVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ofertasCell", for: indexPath) as! OfertasCell
        let evento = listaEventos[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(evento, lat: (filtroSeleccionado["desdelat"] as? Double) ?? 0.0,lon: (filtroSeleccionado["desdelon"] as? Double) ?? 0.0)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaEventos.count
    }
}


