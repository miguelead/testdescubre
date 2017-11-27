//
//  RutaVC.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/22/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class RutaVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var listaderutasdeinteres = [RutaDeInteres]()

    override func viewDidLoad() {
        super.viewDidLoad()
        listaderutasdeinteres.append(RutaDeInteres(ROIId: 1, titulo: "La ruta del pan", categoria: "Restaurantes, Panadería", autor: "Pedro Perez", autorcat: "Gastronomía", photo: "https://media-cdn.tripadvisor.com/media/photo-s/0a/61/eb/0e/photo0jpg.jpg"))
        

        listaderutasdeinteres.append(RutaDeInteres(ROIId: 2, titulo: "10 lugares para visitar", categoria: "Parques", autor: "Juan Jose", autorcat: "Parques", photo: "https://photo620x400.mnstatic.com/51271bc32d0a9d1baf4bdbde73e7deef/parque-la-llovizna.jpg"))
        
        
        listaderutasdeinteres.append(RutaDeInteres(ROIId: 2, titulo: "Buenos para merendar", categoria: "Parques", autor: "Juan Jose", autorcat: "Parques", photo: "https://igx.4sqi.net/img/general/200x200/32552270_sxGuNSMsM028bE7JBfK8xifO5q6YaVeB6kYlMl8VqVs.jpg"))

     

        self.tableView.dataSource = self
        self.tableView.delegate = self
       
    }
    
  }


extension RutaVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rutacell", for: indexPath) as! rutacell
        let puntos = listaderutasdeinteres[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(puntos)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaderutasdeinteres.count
    }
    
}
