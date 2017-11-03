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
//        print("Filtro elegido es : \(filtroelegido)")
        print("Filtro elegido es : \(filtroSeleccionado)")

        //        ordenarporFiltrarVC()
        
        tableView.reloadData()
    }
//    
//    func guardarFiltrar(data: Int) {
//        filtroelegido = data
//        
//    }


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
    
//    
//    func filtraporFiltrarVC(){
//        if filtroelegido.filtro == 1{
//            let ordenyfiltrolistapuntodeinteres.filter({$0._tipo == "DOR"})
//        }
//    
//    }
//    
  
    func probarAlamo(){
    
        let ruta = "http://emprenomina.com/recomendacion/concepto/"
            
        let param: [String: Any] = [
            "usuarioActivo": "6",
            "coordenada": [
                "lat": "8.2905291",
                "lon": "-62.7395511"
            ],
            "kmAlrededor":"3",
            "ciudad": "5",
            "conceptos": [""],
            "caracteristicas": [""],
            "clima":"",
            "hora": "",
            "N": "10",
            "ordenamiento": "Rating",
            "sitios": [],
            "descubre":"0",
            "auto" : "0"
        ]
        
        
        
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

    
//  Llenar listapuntodeinteres de tipo PuntoDeInteres
    

//    func parsePOICSV(){
//        
//        let path = Bundle.main.path(forResource: "datos6", ofType: "csv")
//        
//        do {
//            let csv = try CSV(contentsOfURL: path!)
//            let rows = csv.rows
//            for row in rows{
//
//                let POIId = Int(row["ID"]!)!
//                let titulo = row["TITULO"]!
//                let tipo = row["TIPO"]!
//                let categoria = row["CAT1"]!
//                let direccion = row["DIRECCION"]!
//                let lat = row["LAT"]!
//                let lon = row["LON"]!
//                let precio = Int(row["PRECIO"]!)!
//                let recom_index = Int(row["RECOM_INDEX"]!)!
//                let cercan_index = Int(row["CERCAN_INDEX"]!)!
//                let popular_index = Int(row["POPULAR_INDEX"]!)!
//                
//                
//                let POItemporal = PuntoDeInteres(POIId: POIId, titulo: titulo, tipo: tipo, categoria: categoria, direccion: direccion, lat : lat, lon : lon, precio: precio, recom_index : recom_index, cercan_index : cercan_index,popular_index : popular_index)
// 
//                listapuntodeinteres.append(POItemporal)
//            
//            }
//        
//        }catch let err as NSError {
//            print (err.debugDescription)
//        
//        }
//    
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! puntodeinteresCell
        
        let puntos : PuntoDeInteres
        
//        puntos = filteredlistapuntodeinteres[indexPath.row]
//        if filtroelegido == 1 {print("\(puntos._recom_index) - \(puntos._titulo)")}
//        if filtroelegido == 2 {print("\(puntos._cercan_index) - \(puntos._titulo)")}
//        if filtroelegido == 3 {print("\(puntos._precio) - \(puntos._titulo)")}
//        if filtroelegido == 4 {print("\(puntos._popular_index) - \(puntos._titulo)")}

        
        
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
//            FiltrarVC.filtroElegido = filtroelegido
            FiltrarVC.filtroSeleccionado = filtroSeleccionado
        }
    }
  
}

