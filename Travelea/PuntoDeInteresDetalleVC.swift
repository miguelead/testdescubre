//
//  PuntoDeInteresDetalleCV.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 20/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class PuntoDeInteresDetalleVC: UIViewController {

    @IBOutlet weak var distanciaLbl: UILabel!
    @IBOutlet weak var precioLbl: UILabel!
    @IBOutlet weak var tituloLbl: UILabel!
    @IBOutlet weak var categoriaLbl: UILabel!
    @IBOutlet weak var direccionLbl: UILabel!
    @IBOutlet weak var imagenLugar: UIImageView!
    @IBOutlet weak var descripcion: UILabel!
//    @IBOutlet weak var servicios: UILabel!
    
    @IBOutlet weak var caracteristicas: UILabel!
    @IBOutlet weak var llamarLabel: UIButton!
    @IBOutlet weak var contactarLabel: UIButton!
    @IBOutlet weak var sitioWeb: UIButton!
    
    var punto: PuntoDeInteres!
    var distanciaActual: CLLocationCoordinate2D!
    
    @IBAction func testCheckin(_ sender: Any) {
    
            let user_id = CurrentUser.shared?._uid
            var body:[String: Any] = [:]
            body["comment"] = "test"
            body["tourist_id"] = user_id
            body["poi_id"] = self.punto._POIId
            let ruta = KRutaMain + "/perfil/API/checkin/"
            Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                guard 200...300 ~= (response.response?.statusCode ?? -999)
                    else {
                        UIAlertController.presentViewController(title: "Error", message: "No se pudo hacer Check In en el sitio", view: self)
                        return
                }
                
                UIAlertController.presentViewController(title: "", message: "¡Felicidades haz hecho Check In en el lugar!", view: self, successEvent: {_ in
                    print("test")
                
                
                })
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "bookMark",
            let vc = segue.destination as? MarkBookViewController,
            let punto = sender as? PuntoDeInteres{
            vc.puntodeinteres = punto
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hifivalen25-9"), style: .plain, target: self, action: #selector(updateStateBookMark))

        self.fillData()
        UIApplication.shared.isNetworkActivityIndicatorVisible =  true
        self.consultaApi()
    }
    
  
    
    func updateStateBookMark(){
        self.performSegue(withIdentifier: "bookMark", sender: self.punto)
    }
    
    func fillData(){
        self.navigationController?.title = punto._titulo
        self.tituloLbl.text = punto._titulo
        self.precioLbl.text = punto._precio
        let distanciaMetros = self.punto.distanciaActual(lat: distanciaActual.latitude, lon: distanciaActual.longitude)
        if distanciaMetros >= 1000{
            self.distanciaLbl.text = "\(Int(distanciaMetros / 1000))km"
        } else {
            self.distanciaLbl.text = "\(distanciaMetros)m"
        }
        if !punto._photo.isEmpty, let url = URL(string: punto._photo){
            self.imagenLugar.kf.setImage(with: url)
        }
        self.categoriaLbl.text = punto._categoria
        self.direccionLbl.text = punto._direccion
        self.descripcion.text = punto._info
        self.caracteristicas.text = ""
        self.llamarLabel.isEnabled = !punto._telf.isEmpty
        self.contactarLabel.isEnabled = !punto._mail.isEmpty
        self.sitioWeb.isEnabled = !punto._web.isEmpty
    }
    
    func consultaApi(){
        let url = KRutaMain + "/base/api/\(punto._POIId)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let result = response.result.value as? [String:Any] else {
                return
            }
        
            self.descripcion.text = "\(result["description"]!)"
            
            var propiedades: [[String: Any]] = [[:]]
            var propiedadestext: String = ""
            propiedades = result["properties"] as! [[String : Any]]
            print(propiedades.count)
            var counter: Int = 0
            for propDict in propiedades {
                counter += 1
                let propiedad = propDict["name"]
                print("\(propiedad!)")
                
                if propiedades.count == counter{
                    propiedadestext += "\(propiedad!)"
                }else{
                    propiedadestext += "\(propiedad!), "
                }
            }
            self.caracteristicas.text = "\(propiedadestext)"

        }
    }
    
    @IBAction func llamarSitio(_ sender: Any) {
    }
    

    @IBAction func sitioWeb(_ sender: Any) {
    }

    
    @IBAction func contactarCorreo(_ sender: Any) {
    }


}
