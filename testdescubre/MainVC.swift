//
//  ViewController.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 5/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Alamofire


class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, GuardarFiltrarDelegate{
 
    @IBOutlet weak var tableView: UITableView!
    
    var filtroelegido = 1
    var listapuntodeinteres = [PuntoDeInteres]()
    var filteredlistapuntodeinteres = [PuntoDeInteres]()
    
    
    var filtroSeleccionado : [String:Any] = [
        "hubocambio" : false,
        "mapa": false,
        "desdelat": 0.0,
        "desdelon": 0.0,
        "hastakm": 1,
        "ordenarpor": 1,
        "filtrarpor": 1
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        probarAlamo()
        tableView.dataSource = self
        tableView.delegate = self
        
        
//        parsePOICSV()
        
      }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        print("Filtro elegido es : \(filtroSeleccionado)")


        listapuntodeinteres.removeAll()
        probarAlamo()
        tableView.reloadData()
    }


    func guardarFiltrar(data: [String:Any]) {
        filtroSeleccionado = data

    }
    
    
    func ordenarporFiltrarVC(){
        if filtroelegido == 1 {
            filteredlistapuntodeinteres = listapuntodeinteres.sorted(by: {$0._recom_index > $1._recom_index})
        }
        if filtroelegido == 2 {
            filteredlistapuntodeinteres = listapuntodeinteres.sorted(by: {$0._cercan_index < $1._cercan_index})
        }
        if filtroelegido == 3 {
            filteredlistapuntodeinteres = listapuntodeinteres.sorted(by: {$0._precio < $1._precio})
        }
        if filtroelegido == 4 {
            filteredlistapuntodeinteres = listapuntodeinteres.sorted(by: {$0._popular_index > $1._popular_index})
        }
    }
 
  
    func probarAlamo(){
    

        let desdelatParam = filtroSeleccionado["desdelat"] as! Double
        let desdelonParam = filtroSeleccionado["desdelon"] as! Double
        
        var ordenarporParam : String = "null"
        if filtroSeleccionado["ordenarpor"] as! Int == 1 {ordenarporParam = "Rating"}
        if filtroSeleccionado["ordenarpor"] as! Int == 2 {ordenarporParam = "Distancia"}
        if filtroSeleccionado["ordenarpor"] as! Int == 3 {ordenarporParam = "Precio"}
        if filtroSeleccionado["ordenarpor"] as! Int == 4 {ordenarporParam = "Popularidad"}
        
        var filtrarporParam : String
        if filtroSeleccionado["filtrarpor"] as! Int == 1 {filtrarporParam = "test1"}
        if filtroSeleccionado["filtrarpor"] as! Int == 2 {filtrarporParam = "test2"}
        if filtroSeleccionado["filtrarpor"] as! Int == 3 {filtrarporParam = "test3"}
        if filtroSeleccionado["filtrarpor"] as! Int == 4 {filtrarporParam = "test4"}
        
     
        let hastakmParam : Int = filtroSeleccionado["hastakm"] as! Int
        
        let ruta = "http://emprenomina.com/recomendacion/concepto/"

        let param: [String: Any] = [
            "usuarioActivo": "6",
            "coordenada": [
                "lat": "\(desdelatParam)",
                "lon": "\(desdelonParam)"
            ],
            "kmAlrededor":"\(hastakmParam)",
            "ciudad": "",
            "conceptos": [""],
            "caracteristicas": [""],
            "clima" : "",
            "hora": "",
            "N": "10",
            "ordenamiento": "\(ordenarporParam)",
            "sitios": [],
            "descubre":"0",
            "auto" : "0"
        ]
        
        print ("......................")
        print ("......................")
        print ("......................")
        print (param)
        print ("......................")
        print ("......................")
        print ("......................")
        print ("......................")
        
        
        Alamofire.request(ruta, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in

            print(response)
            
            guard let result = response.result.value as? [[String:Any]] else {
                return
            }
            
            let tipo = "test"
            let lat = "test"
            let lon = "test"
            let cercan_index = "2"
            let popular_index = "3"
            
            
            for elemento in result {
                
                let POIId = elemento["id"] as! Int
                let titulo = elemento["titulo"] as! String
                let recom_index = elemento["valor"] as! Float
                let categoria = elemento["categoria"] as! String
                let direccion = elemento["direccion"] as! String
                let precio = elemento["precio"] as! String
                
                let POItemporal = PuntoDeInteres(POIId: POIId, titulo: titulo, tipo: tipo, categoria: categoria, direccion: direccion, lat : lat, lon : lon, precio: precio, recom_index : recom_index, cercan_index : cercan_index,popular_index : popular_index)


                print(POItemporal._titulo)

                self.listapuntodeinteres.append(POItemporal)
                
            }
            
            self.tableView.reloadData()
            
          
        }
    
    }

    
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! puntodeinteresCell
        
        let puntos : PuntoDeInteres
        
        puntos = listapuntodeinteres[indexPath.row]
        cell.configureCell(puntos)
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listapuntodeinteres.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarFiltrarVC"{
            let FiltrarVC : FiltrarVC = segue.destination as! FiltrarVC
            FiltrarVC.delegate = self
            FiltrarVC.filtroSeleccionado = filtroSeleccionado
        }
        
        if segue.identifier == "mostrarDetalleVC"{
//            let DetalleVC : 
        
        }
    }
    
    
  
}

