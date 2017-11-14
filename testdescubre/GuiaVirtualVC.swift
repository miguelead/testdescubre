//
//  GuiaVirtualVC.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 20/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import CoreLocation

class GuiaVirtualVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buscador: UITextField!
    
    var listapuntodeinteres = [PuntoDeInteres]()
    var locManager = CLLocationManager()
    var locacionActual:  CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        let imageView = UIImageView(image: #imageLiteral(resourceName: "hifivalen25-8"))
        imageView.image = imageView.changeImageColor(color: UIColor.hexStringToUIColor(hex: "11A791"))
        self.navigationItem.titleView = imageView
        buscador.layer.borderColor = UIColor.hexStringToUIColor(hex: "11A791").cgColor
        buscador.layer.borderWidth = 1.5
        buscador.delegate = self
        self.navigationController?.navigationBar.shadowImage = UIImage()
        obtenerLocalizacionActual()
    }

    func obtenerLocalizacionActual(){
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.requestLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarPuntoDeInteresDetalleCV"{
        }
    }
    
}

extension GuiaVirtualVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! puntodeinteresCell
        let puntos = listapuntodeinteres[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(puntos, lat: locacionActual?.latitude ?? 0.0,lon: locacionActual?.longitude ?? 0.0)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listapuntodeinteres.count
    }
}

extension GuiaVirtualVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last{
            self.locacionActual = last.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error localizacion")
    }
}

extension GuiaVirtualVC: UITextFieldDelegate{



}
