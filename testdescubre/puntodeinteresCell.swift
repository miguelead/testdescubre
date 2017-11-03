//
//  puntodeinteresCell.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class puntodeinteresCell: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var precio: UILabel!

    var puntodeinteres : PuntoDeInteres!

    func configureCell(_ puntodeinteres: PuntoDeInteres!){
        self.puntodeinteres = puntodeinteres
        
        titulo.text = self.puntodeinteres._titulo
        categoria.text = self.puntodeinteres._categoria
        direccion.text = self.puntodeinteres._direccion
        precio.text = String(self.puntodeinteres._precio)
        
        
        
    }
    
    
    
    
    
}
