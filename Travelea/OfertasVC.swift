//
//  OfertasViewController.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/15/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class OfertasVC: UIViewController {
    
    var delegate: DescubreFilterVC?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filtrosLabel: UILabel!
    
    var ActualRequest: Int?
    var listaOfertas = [Ofertas]()
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
        
        //        listaOfertas.append(Ofertas.init(id: 1, idEmpresa: 1, empresa: "Empresa 1", titulo: "2x1 en birras", categoria: "prueba", fechaInicial: "10 dic", fechaFinal: "11 dic", tipo: "tipo", descripcion: "ven con tus amigos mas cheveres", photo: "prueba"))
        //        listaOfertas.append(Ofertas.init(id: 2, idEmpresa: 1, empresa: "Empresa 1", titulo: "2x1 en birras", categoria: "prueba", fechaInicial: "10 dic", fechaFinal: "11 dic", tipo: "tipo", descripcion: "ven con tus amigos mas cheveres", photo: "prueba"))
        //        listaOfertas.append(Ofertas.init(id: 3, idEmpresa: 1, empresa: "Empresa 1", titulo: "2x1 en birras", categoria: "prueba", fechaInicial: "10 dic", fechaFinal: "11 dic", tipo: "tipo", descripcion: "ven con tus amigos mas cheveres", photo: "prueba"))
        //        listaOfertas.append(Ofertas.init(id: 4, idEmpresa: 1, empresa: "Empresa 1", titulo: "2x1 en birras", categoria: "prueba", fechaInicial: "10 dic", fechaFinal: "11 dic", tipo: "tipo", descripcion: "ven con tus amigos mas cheveres", photo: "prueba"))
        //
        
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
        
        
        let ruta = kRutaSecundaria + "/base/api/promocion/"
        
        Alamofire.request(ruta, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            self.refreshControl.endRefreshing()
            
            guard let result = response.result.value as? [[String:Any]]
                else {
                    if self.listaOfertas.isEmpty{
                        self.addBackgroundImage()
                    } else {
                        self.tableView.backgroundView = nil
                    }
                    return
            }
            
            self.listaOfertas.removeAll()
            
            
            for elemento in result {
                if  let id = elemento["id"] as? Int,
                    let titulo = elemento["descripcion"] as? String,
                    let idEmpresa = elemento["idEmpresa"] as? Int,
                    let empresa = elemento["empresa"] as? String,
                    let categoria = elemento["categoria"] as? String,
                    let fechaInicial = elemento["fechaInicial"] as? String,
                    let fechaFinal = elemento["fechaFinal"] as? String,
                    let tipo = elemento["tipo"] as? String,
                    let descripcion = elemento["descripcion"] as? String
                {
                    let temporal = Ofertas.init(id: id, idEmpresa: idEmpresa, empresa: empresa, titulo: titulo, categoria: categoria, fechaInicial: fechaInicial, fechaFinal: fechaFinal, tipo: tipo, descripcion: descripcion, photo: elemento["photo"] as? String ?? "")
                    self.listaOfertas.append(temporal)
                }
                
            }
            
            if self.listaOfertas.isEmpty{
                self.addBackgroundImage()
            } else {
                self.filtrosLabel.text = "Ofertas cerca de ti"
                //                self.filtrosLabel.text = "Ofertas de " + filtrarporParam + " ordenados por " + ordenarporParam
                self.tableView.backgroundView = nil
            }
            self.tableView.reloadData()
        }
        
        
        
    }
    
    func addBackgroundImage(){
        let image = #imageLiteral(resourceName: "emptystate-12").withRenderingMode(.alwaysTemplate)
        let topMessage = "Descubre Nuevas Ofertas"
        let bottomMessage = "Haz pull para consultar de nuevo"
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        tableView.backgroundView = emptyBackgroundView
    }
    
}

extension OfertasVC: DescubreFilterVC{
    func parseFilter(filter: [String:Any]){
        self.filtroSeleccionado = filter
        consultaApi()
    }
}


extension OfertasVC: CLLocationManagerDelegate{
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

extension OfertasVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ofertasCell", for: indexPath) as! OfertasCell
        let oferta = listaOfertas[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(oferta, lat: (filtroSeleccionado["desdelat"] as? Double) ?? 0.0,lon: (filtroSeleccionado["desdelon"] as? Double) ?? 0.0)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaOfertas.count
    }
    
}

