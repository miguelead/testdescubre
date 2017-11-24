//
//  puntodeinteresCell.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class puntoInteresCheck: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var imageLugar: UIImageView!
    var puntodeinteres : Places!

    
    func configureCell(_ puntodeinteres: Places){
        titulo.text = puntodeinteres.name
        categoria.text = puntodeinteres.tipo
        direccion.text = puntodeinteres.ubicacion
        if !puntodeinteres.photo.isEmpty, let url = URL(string: puntodeinteres.photo){
            self.imageLugar.kf.setImage(with: url)
        }
        if puntodeinteres.isSelected{
            self.checkImage.isHidden = false
        } else {
            self.checkImage.isHidden = true
        }
    }
    
}
