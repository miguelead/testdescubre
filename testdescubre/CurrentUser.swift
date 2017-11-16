//
//  Usuario.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/15/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation



class CurrentUser {
    
    var _id: Int
    var _nombre: String
    var _mail: String
    var _location: String

    static var shared : CurrentUser?
    
    //ID,TITULO,TIPO,CAT1,DIRECCION,LAT,LON,PRECIO,RECOM_INDEX,CERCAN_INDEX,POPULAR_INDEX
    init(id: Int, nombre: String, mail: String, location: String){
        _id = id
        _nombre = nombre
        _mail = mail
        _location = location
    }
}
