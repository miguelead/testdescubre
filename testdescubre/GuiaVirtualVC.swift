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
    var ActualRequest: Int?
 

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
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    func actualizarTitulo(){
        if let user = CurrentUser.shared{
            self.nameLabel.text = "¿" + user._nombre + " en que puedo ayudarte?"
        } else {
        self.nameLabel.text = "¿En que puedo ayudarte?"
        }
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
        if segue.identifier == "mostrarPuntoDeInteresDetalleCV",
            let vc = segue.destination as? PuntoDeInteresDetalleVC,
            let cell = sender as? PuntodeinteresCell{
            vc.punto = cell.puntodeinteres
        }
    }
    
    func consultaApi(ubicacionActual: CLLocation){
        guard let query = buscador.text, let user = CurrentUser.shared else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
        
        var ruta = kRuta + "/search?"
        ruta += "query=" + query
        ruta += "&lat=\(ubicacionActual.coordinate.latitude)"
        ruta += "&lng=\(ubicacionActual.coordinate.longitude)"
        ruta += "&qtime=\(NSDate().timeIntervalSince1970)"
        ruta += "&sort_by=Rating"
        ruta += "&discover=0"
        ruta += "&limit=\(kLimitPag)"
        ruta += "&offset=\(self.listapuntodeinteres.count)"
        ruta += "&user_id=\(user._id)"
        ruta += "&radius=\(kMaxKm)"
        ruta += "&transport=car"
        
        guard let rutaValidada = ruta.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
        
        Alamofire.request(rutaValidada, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let result = response.result.value as? [String:Any],
                let response = result["response"] as? [String:Any],
                let meta = result["meta"] as? [String:Any],
                let RequestId = meta["requestID"] as? Int,
                let listElement = response["items"] as? [[String:Any]]
                else {
                    if self.listapuntodeinteres.isEmpty{
                        self.addBackgroundImage()
                    } else {
                        self.tableView.backgroundView = nil
                    }
                    return
            }
            self.ActualRequest = RequestId
            self.listapuntodeinteres.removeAll()
            for elemento in listElement {
                if let POIId = elemento["id"] as? Int, let titulo = elemento["name"] as? String,
                    let recom_index = elemento["rating"] as? Float, let categoria = elemento["category"] as? String,
                    let direccion = elemento["address"] as? String, let precio = elemento["price"] as? String,
                    let lat = elemento["lat"] as? String, let lon = elemento["lng"] as? String,
                    let photo = elemento["photo"] as? String{
                    let POItemporal = PuntoDeInteres(POIId: POIId, titulo: titulo, categoria: categoria, direccion: direccion, lat : lat, lon : lon, precio: precio, recom_index : recom_index, photo: photo)
                    self.listapuntodeinteres.append(POItemporal)
                }
            }
            if self.listapuntodeinteres.isEmpty{
                self.addBackgroundImage()
            } else {
                self.tableView.backgroundView = nil
            }
            self.tableView.reloadData()
        }
        }
    
    func addBackgroundImage(){
        let image = #imageLiteral(resourceName: "hifivalen25-8").withRenderingMode(.alwaysTemplate)
        let topMessage = "¿Necesitas ayuda?"
        let bottomMessage = "No se han encontrado lugares con esos terminos"
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableView.backgroundView = emptyBackgroundView
    }
}

    


extension GuiaVirtualVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! PuntodeinteresCell
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
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
        
        self.listapuntodeinteres.removeAll()
        self.tableView.reloadData()
        self.buttomContraintTextfield.isActive = text.isEmpty
        self.topContraintTexfield.isActive = !text.isEmpty
        self.viewInfo.isHidden = !text.isEmpty
        self.tableView.isHidden = text.isEmpty
        
        if !text.isEmpty{
            self.nameLabel.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion:nil)
            
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion:{ _ in
                self.nameLabel.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            })}
            self.obtenerLocalizacionActual()
    }
}
