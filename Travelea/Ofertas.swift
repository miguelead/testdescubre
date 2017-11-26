//
//  puntodeinteres.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation
import CoreLocation


class Ofertas {
    
    var _id: Int
    var _idEmpresa: Int
    var _empresa: String
    var _titulo: String
    var _categoria: String
    var _fechaInicial: String
    var _fechaFinal: String
    var _tipo: String
    var _descripcion: String
    var _photo: String
    
 
    init(id: Int, idEmpresa: Int, empresa: String, titulo: String, categoria: String,
         fechaInicial: String, fechaFinal: String, tipo: String, descripcion: String, photo: String){
        _id = id
        _idEmpresa = idEmpresa
        _titulo = titulo
        _categoria = categoria
        _fechaInicial = fechaInicial
        _fechaFinal = fechaFinal
        _tipo = tipo
        _descripcion = descripcion
        _photo = photo
        _empresa = empresa

    }
    

}
