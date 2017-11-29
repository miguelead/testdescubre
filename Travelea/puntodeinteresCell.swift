//
//  puntodeinteresCell.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

protocol PuntoDeInteresDelegate {
    func moveMarkBook(punto: PuntoDeInteres)
}
class PuntodeinteresCell: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var distancia: UILabel!
    @IBOutlet weak var markbook: UIButton!
    @IBOutlet weak var imageLugar: UIImageView!
    var puntodeinteres : PuntoDeInteres!
    var delegate: PuntoDeInteresDelegate?

    
    func configureCell(_ puntodeinteres: PuntoDeInteres, lat: Double, lon: Double){
        self.puntodeinteres = puntodeinteres
        titulo.text = self.puntodeinteres._titulo
        categoria.text = self.puntodeinteres._categoria
        direccion.text = self.puntodeinteres._direccion
        precio.text = self.puntodeinteres._precio
        let distanciaMetros = self.puntodeinteres.distanciaActual(lat: lat, lon: lon)
        if distanciaMetros >= 1000{
            self.distancia.text = "\(Int(distanciaMetros / 1000))km"
        } else {
            self.distancia.text = "\(distanciaMetros)m"
        }
        let image = #imageLiteral(resourceName: "hifivalen25-9").withRenderingMode(.alwaysTemplate)
        markbook.setImage(image, for: .normal)
        if !puntodeinteres._photo.isEmpty,let url = URL(string: puntodeinteres._photo){
            self.imageLugar.kf.setImage(with: url)
        }
        markbook.tintColor = UIColor.hexStringToUIColor(hex: "00B19C")
    }
    
    @IBAction func markbookLocation(_ sender: UIButton) {
        self.delegate?.moveMarkBook(punto: puntodeinteres)
        
    }
   
}
