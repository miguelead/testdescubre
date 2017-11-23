//
//  TableroViewController.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Firebase

class TableroViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var channelRef: DatabaseReference!
    var listapuntodeinteres: [PuntoDeInteresTablero] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    @IBAction func addLogic(_ sender: Any) {
    }
}

extension TableroViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! puntodeinteresTableroCell
        let puntos = listapuntodeinteres[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(puntos, lat: 0.0,lon: 0.0)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listapuntodeinteres.count
    }
    
}
