//
//  puntodeinteresCell.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class OfertasCell: UITableViewCell {
  

    @IBOutlet weak var tipo: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var empresa: UILabel!
    @IBOutlet weak var tituloEvento: UILabel!
    @IBOutlet weak var EmpresaImage: UIImageView!
    var oferta : Ofertas?
    var evento : Eventos?
    
    func configureCell(_ oferta: Ofertas, lat: Double, lon: Double){
        self.oferta = oferta
        tituloEvento.text = oferta._titulo
        categoria.text = oferta._categoria
        empresa.text = oferta._empresa
        tipo.text = oferta._tipo
        fecha.text = oferta._fechaInicial + " al " + oferta._fechaFinal
        if !oferta._photo.isEmpty,let url = URL(string: oferta._photo){
            self.EmpresaImage.kf.setImage(with: url)
        }
    }
    
    func configureCell(_ evento: Eventos, lat: Double, lon: Double){
        self.evento = evento
        tituloEvento.text = evento._titulo
        categoria.text = evento._categoria
        empresa.text = evento._empresa
        tipo.text = evento._tipo
        fecha.text = evento._fechaInicial + " al " + evento._fechaFinal
        if !evento._photo.isEmpty,let url = URL(string: evento._photo){
            self.EmpresaImage.kf.setImage(with: url)
        }
    }
}
