//
//  puntodeinteres.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation
import CoreLocation


class PuntoDeInteres {
    
    var _POIId: Int
    var _titulo: String
    var _categoria: String
    var _direccion: String
    var _lat: String
    var _lon: String
    var _precio: String
    var _recom_index : Float
    var _photo : String
    var _bookmark: Bool = false
    var _telf : String = ""
    var _mail : String = ""
    var _web : String = ""
    var _info: String = ""
    
    //ID,TITULO,TIPO,CAT1,DIRECCION,LAT,LON,PRECIO,RECOM_INDEX,CERCAN_INDEX,POPULAR_INDEX
    init(POIId: Int, titulo: String, categoria: String, direccion: String,
         lat: String, lon: String, precio: String, recom_index: Float, photo: String, telf: String = "", mail: String = "", web: String = "", info: String = ""){
        _POIId = POIId
        _titulo = titulo
        _categoria = categoria
        _direccion = direccion
        _lat = lat
        _lon = lon
        _precio = precio
        _recom_index = recom_index
        _photo = photo
        _telf = telf
        _mail = mail
        _web = web
        _info = info
    }
    
    func distanciaActual(lat: Double, lon: Double) -> Int{
        let coordinateA: CLLocation =  CLLocation(latitude: lat, longitude: lon)
        let coordinateB: CLLocation =  CLLocation(latitude: Double(_lat) ?? 0, longitude: Double(_lon) ?? 0)
        return Int(coordinateA.distance(from: coordinateB))
    }

}
