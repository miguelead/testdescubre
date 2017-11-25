//
//  BuzonPerfilTVC.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/25/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class BuzonPerfilTVC: UITableViewController {

    var filtroSeleccionado : [String:Any] = [
        "mapa": false,
        "desdelat": 0.0,
        "desdelon": 0.0,
        "hastakm": 1,
        "ordenarpor": 1,
        "filtrarpor": 1
    ]

    var listaobjetos:[Any] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        listaobjetos.append(PuntoDeInteres.init(POIId: 1, titulo:"test", categoria: "test", direccion: "test", lat: "test", lon: "test", precio: "test", recom_index: 1, photo: "test"))

        listaobjetos.append(Ofertas.init(id: 2, idEmpresa: 3, empresa: "test", titulo: "test", categoria: "test", fechaInicial: "test", fechaFinal: "test", tipo: "test", descripcion: "test", photo: "test"))
        
        listaobjetos.append(Eventos.init(id: 4, idEmpresa: 3, empresa: "test", titulo: "test", categoria: "test", fechaInicial: "test", fechaFinal: "test", tipo: "test", descripcion: "test", photo: "test"))
        
        listaobjetos.append(PuntoDeInteres.init(POIId: 1, titulo:"test", categoria: "test", direccion: "test", lat: "test", lon: "test", precio: "test", recom_index: 1, photo: "test"))

        listaobjetos.append(PuntoDeInteres.init(POIId: 1, titulo:"test", categoria: "test", direccion: "test", lat: "test", lon: "test", precio: "test", recom_index: 1, photo: "test"))

        listaobjetos.append(PuntoDeInteres.init(POIId: 1, titulo:"test", categoria: "test", direccion: "test", lat: "test", lon: "test", precio: "test", recom_index: 1, photo: "test"))

        listaobjetos.append(PuntoDeInteres.init(POIId: 1, titulo:"test", categoria: "test", direccion: "test", lat: "test", lon: "test", precio: "test", recom_index: 1, photo: "test"))

        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let elemento = listaobjetos[indexPath.row] as? PuntoDeInteres{
            let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! PuntodeinteresCell
            cell.selectionStyle = .none
            cell.configureCell(elemento, lat: (filtroSeleccionado["desdelat"] as? Double) ?? 0.0,lon: (filtroSeleccionado["desdelon"] as? Double) ?? 0.0)
            return cell

            
        }
        
        if let elemento = listaobjetos[indexPath.row] as? Ofertas{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ofertasCell", for: indexPath) as! OfertasCell
            cell.selectionStyle = .none
            cell.configureCell(elemento, lat: (filtroSeleccionado["desdelat"] as? Double) ?? 0.0,lon: (filtroSeleccionado["desdelon"] as? Double) ?? 0.0)
            return cell

            
        }
        
        if let elemento = listaobjetos[indexPath.row] as? Eventos{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ofertasCell", for: indexPath) as! OfertasCell
            cell.selectionStyle = .none
            cell.configureCell(elemento, lat: (filtroSeleccionado["desdelat"] as? Double) ?? 0.0,lon: (filtroSeleccionado["desdelon"] as? Double) ?? 0.0)
            return cell

            
        }
        return UITableViewCell()


    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaobjetos.count
    }


}
 
