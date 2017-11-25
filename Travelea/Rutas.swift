//
//  Rutas.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/22/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation

class RutaDeInteres {
    
    var _ROIId: Int
    var _titulo: String
    var _categoria: String
    var _autor: String
  
    var _photo : String
    
    init(ROIId: Int, titulo: String, categoria: String, autor: String, photo: String){
        _ROIId = ROIId
        _titulo = titulo
        _autor = autor
        _categoria = categoria
        _photo = photo
    }
    
    
}
