//
//  GuiaVirtualVC.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 20/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import Speech

class GuiaVirtualVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buscador: UITextField!
    @IBOutlet weak var viewInfo: UIView!

    @IBOutlet weak var buttomContraintTextfield: NSLayoutConstraint!
    @IBOutlet weak var topContraintTexfield: NSLayoutConstraint!
    
    var listapuntodeinteres = [PuntoDeInteres]()
    var locManager = CLLocationManager()
    var localizacionActual: CLLocationCoordinate2D?
 

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
        actualizarTitulo()
    }

    func actualizarTitulo(){
        let userName = "Miguel"
        self.nameLabel.text = "¿" + userName + " en que puedo ayudarte?"
    
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
    
    func consultaApi(ubicacionActual: CLLocation){
        let ruta = "http://emprenomina.com/recomendacion/concepto/"
        let param: [String: Any] = [
            "usuarioActivo": "6",
            "coordenada": [
                "lat": "\(ubicacionActual.coordinate.latitude)",
                "lon": "\(ubicacionActual.coordinate.longitude)"
            ],
            "kmAlrededor": "\(kMaxKm)",
            "clima" : "",
            "ciudad": "",
            "hora": "",
            "conceptos": [""],
            "caracteristicas": [""],
            "N": NUMBER_LIST,
            "ordenamiento": "Rating",
            "sitios": [],
            "descubre":"0",
            "auto" : "0"
            //"query": filtrarporParam
        ]
        
        // cambiar endpoint por esto
        //user_id
        //query -filtrarpOR
        //lat
        //lng
        //wheater
        //qtime
        //sort_by
        //discover
        //radius
        //limit
        //offset
        
        
        Alamofire.request(ruta, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print(response)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let result = response.result.value as? [[String:Any]] else {
                return
            }
            let tipo = "test"
            let lat = "test"
            let lon = "test"
            self.listapuntodeinteres.removeAll()
            for elemento in result {
                if let POIId = elemento["id"] as? Int, let titulo = elemento["titulo"] as? String,
                    let recom_index = elemento["valor"] as? Float, let categoria = elemento["categoria"] as? String,
                    let direccion = elemento["direccion"] as? String, let precio = elemento["precio"] as? String{
                    let POItemporal = PuntoDeInteres(POIId: POIId, titulo: titulo, tipo: tipo, categoria: categoria, direccion: direccion, lat : lat, lon : lon, precio: precio, recom_index : recom_index)
                    self.listapuntodeinteres.append(POItemporal)
                }
            }
            self.tableView.reloadData()
        }
        
    }

    
}

extension GuiaVirtualVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! puntodeinteresCell
        let puntos = listapuntodeinteres[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(puntos, lat: localizacionActual?.latitude ?? 0.0,lon: localizacionActual?.longitude ?? 0.0)
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
            self.localizacionActual = last.coordinate
            consultaApi(ubicacionActual: last)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error localizacion")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension GuiaVirtualVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            self.nameLabel.isHidden = false
            self.buttomContraintTextfield.isActive = true
            self.topContraintTexfield.isActive = false
            self.viewInfo.isHidden = false
            self.tableView.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion:{ _ in
                self.nameLabel.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            })
            return
        }

            self.buttomContraintTextfield.isActive = text.isEmpty
            self.topContraintTexfield.isActive = !text.isEmpty
            self.viewInfo.isHidden = !text.isEmpty
            self.tableView.isHidden = text.isEmpty
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion:{ _ in
            self.nameLabel.isHidden = !text.isEmpty
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        })
    }
}
