//
//  AutorRutaDeInteresDetalle.swift
//  Travelea
//
//  Created by Momentum Lab 2 on 11/27/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import Foundation

class AutorRutaDeInteresDetalle {
    
    
    var _tituloruta: String
    var _subtituloruta: String
    var _descripcionruta: String
    var _photo : String
    var _nombre : String = ""
    var _descripcionautor : String = ""
    
    
    
    init(tituloruta: String, subtituloruta: String, descripcionruta: String, photo: String, nombre: String = "", descripcionautor: String = ""){
        
        _tituloruta = tituloruta
        _subtituloruta = subtituloruta
        _descripcionruta = descripcionruta
        _photo = photo
        _nombre = nombre
        _descripcionautor = descripcionautor
    }
    
    
    
}


