//
//  rutadetallecell.swift
//  Travelea
//
//  Created by Momentum Lab 2 on 11/27/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import UIKit

class rutadetallecell: UITableViewCell {

    @IBOutlet weak var tituloLbl: UILabel!
    @IBOutlet weak var categoriaLbl: UILabel!
    @IBOutlet weak var direccionLbl: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var resenaLbl: UILabel!
    @IBOutlet weak var telfBtn: UIButton!
    @IBOutlet weak var mailBtn: UIButton!
    @IBOutlet weak var webBtn: UIButton!

    var puntoderutadetalle : RutaDeInteresDetalle!
    
    func configureCell(_ puntoderutadetalle: RutaDeInteresDetalle){
        self.puntoderutadetalle = puntoderutadetalle
        tituloLbl.text = self.puntoderutadetalle._titulo
        categoriaLbl.text = self.puntoderutadetalle._categoria
        direccionLbl.text = self.puntoderutadetalle._direccion
        resenaLbl.text = self.puntoderutadetalle._info
        
        if !puntoderutadetalle._photo.isEmpty,let url = URL(string: puntoderutadetalle._photo){
            self.photoImg.kf.setImage(with: url)
        }
        
       
    }
}
