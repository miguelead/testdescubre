//
//  RutaDeInteresDetalle.swift
//  Travelea
//
//  Created by Momentum Lab 2 on 11/27/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import Foundation


class RutaDeInteresDetalle {
    
    
    var _titulo: String
    var _categoria: String
    var _direccion: String
//    var _lat: String
//    var _lon: String
    
    var _photo : String
    var _telf : String = ""
    var _mail : String = ""
    var _web : String = ""
    var _info: String = ""
    
    
    init(titulo: String, categoria: String, direccion: String, photo: String, telf: String = "", mail: String = "", web: String = "", info: String = ""){
        
        _titulo = titulo
        _categoria = categoria
        _direccion = direccion
        _photo = photo
        _telf = telf
        _mail = mail
        _web = web
        _info = info
    }
    
    
    
}

