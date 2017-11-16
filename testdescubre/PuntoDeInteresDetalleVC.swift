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
    @IBOutlet weak var servicios: UILabel!
    @IBOutlet weak var caracteristicas: UILabel!
    @IBOutlet weak var llamarLabel: UIButton!
    @IBOutlet weak var contactarLabel: UIButton!
    @IBOutlet weak var sitioWeb: UIButton!
    
    var punto: PuntoDeInteres!
   // var distanciaActual: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if punto._bookmark{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hifivalen25-11"), style: .plain, target: self, action: #selector(updateStateBookMark))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.hexStringToUIColor(hex: "11A791")
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hifivalen25-9"), style: .plain, target: self, action: #selector(updateStateBookMark))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.hexStringToUIColor(hex: "11A791")
        }
        self.fillData()
        self.consultaApi()
    }
 
    func updateStateBookMark(){
        if punto._bookmark{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hifivalen25-9"), style: .plain, target: self, action: #selector(updateStateBookMark))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.hexStringToUIColor(hex: "11A791")
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hifivalen25-11"), style: .plain, target: self, action: #selector(updateStateBookMark))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.hexStringToUIColor(hex: "11A791")
        }
        punto._bookmark = !punto._bookmark
    }
    
    func fillData(){
        self.tituloLbl.text = punto._titulo
        self.precioLbl.text = punto._precio
        //self.distanciaLbl.text = "\(punto.distanciaActual(lat: distanciaActual.latitude, lon: distanciaActual.longitude))"
        self.categoriaLbl.text = punto._categoria
        self.direccionLbl.text = punto._direccion
        self.descripcion.text = punto._info
        self.servicios.text = ""
        self.caracteristicas.text = ""
        self.llamarLabel.isEnabled = false
        self.contactarLabel.isEnabled = false
        self.sitioWeb.isEnabled = false
    }
    
    func consultaApi(){
        let url = kRutaSecundaria + "/base/api/\(punto._POIId)"
    }
    
    @IBAction func llamarSitio(_ sender: Any) {
    }
    

    @IBAction func sitioWeb(_ sender: Any) {
    }

    
    @IBAction func contactarCorreo(_ sender: Any) {
    }


}