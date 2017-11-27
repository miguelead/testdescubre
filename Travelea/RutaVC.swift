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
        listaderutasdeinteres.append(RutaDeInteres(ROIId: 1, titulo: "La ruta del pan", categoria: "Cat", autor: "Pedro Perez", photo: "ruta"))
        listaderutasdeinteres.append(RutaDeInteres(ROIId: 2, titulo: "Los mejores cafés", categoria: "Cat", autor: "Maria Perez", photo: "ruta"))
        listaderutasdeinteres.append(RutaDeInteres(ROIId: 3, titulo: "La ruta extrema", categoria: "Cat", autor: "Jose Perez", photo: "ruta"))
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
