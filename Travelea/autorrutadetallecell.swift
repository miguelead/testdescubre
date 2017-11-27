//
//  autorrutadetallecell.swift
//  Travelea
//
//  Created by Momentum Lab 2 on 11/27/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import UIKit

class autorrutadetallecell: UITableViewCell {

    @IBOutlet weak var titulorutaLbl: UILabel!
    @IBOutlet weak var subtitulorutaLbl: UILabel!
    @IBOutlet weak var descripcionrutaLbl: UILabel!
    @IBOutlet weak var autorrutaimg: UIImageView!
    @IBOutlet weak var nombreautorrutaLbl: UILabel!
    @IBOutlet weak var descripcionautorrutaLbl: UILabel!
    
    
    var autorrutadetalle : AutorRutaDeInteresDetalle!
    
    func configureCell(_ autorrutadetalle: AutorRutaDeInteresDetalle){
        self.autorrutadetalle = autorrutadetalle
        
        titulorutaLbl.text = self.autorrutadetalle._tituloruta
        subtitulorutaLbl.text = self.autorrutadetalle._subtituloruta
        descripcionrutaLbl.text = self.autorrutadetalle._descripcionruta
        nombreautorrutaLbl.text = self.autorrutadetalle._nombre
        descripcionautorrutaLbl.text = self.autorrutadetalle._descripcionautor
        
        if !autorrutadetalle._photo.isEmpty,let url = URL(string: autorrutadetalle._photo){
            self.autorrutaimg.kf.setImage(with: url)
        }

        
    }

}
