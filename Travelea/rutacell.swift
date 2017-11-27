//
//  rutacell.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/22/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class rutacell: UITableViewCell {
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var imagenLugar: UIImageView!
    var puntoderuta : RutaDeInteres!
    
    func configureCell(_ puntoderuta: RutaDeInteres){
        self.puntoderuta = puntoderuta
        titulo.text = self.puntoderuta._titulo
        categoria.text = self.puntoderuta._categoria
        autor.text = self.puntoderuta._autor
        if !puntoderuta._photo.isEmpty, let url = URL(string: puntoderuta._photo){
            self.imagenLugar.kf.setImage(with: url)
        }
    }
    
}
