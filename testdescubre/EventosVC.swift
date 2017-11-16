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
        
        guard
            let ordenarPor = filtroSeleccionado["ordenarpor"] as? Int,
            let filtrarPor = filtroSeleccionado["filtrarpor"] as? Int
            else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
        
        self.tableView.reloadData()
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


