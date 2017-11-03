//
//  puntodeinteres.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation
import Alamofire


class PuntoDeInteres {
    var _POIId: Int
    var _titulo: String
    var _tipo: String
    
    var _categoria: String
    var _direccion: String
    var _lat: String
    var _lon: String
    
    var _precio: String
//    
//    var _recom_index : Int
//    var _cercan_index : Int
//    var _popular_index : Int
//    
    var _recom_index : Float
    var _cercan_index : String
    var _popular_index : String
    
    
    //ID,TITULO,TIPO,CAT1,DIRECCION,LAT,LON,PRECIO,RECOM_INDEX,CERCAN_INDEX,POPULAR_INDEX

    
    init(POIId: Int,
         titulo: String,
         tipo: String,
         categoria: String,
         direccion: String,
         lat: String,
         lon: String,
         precio: String,
         recom_index: Float,
         cercan_index: String,
         popular_index: String)
    
        
        
        
        
    {
        
        _POIId = POIId
        _titulo = titulo
        _tipo = tipo
        _categoria = categoria
        _direccion = direccion
        _lat = lat
        _lon = lon
        _precio = precio
        _recom_index = recom_index
        _cercan_index = cercan_index
        _popular_index = popular_index
    }
    
    

//    func downloadPOIDetails(completed: DownloadComplete) {
//        //Alamofire download
//        let currentpoiurl = URL(string: CURRENT_POI_URL)
//        
//        
//        Alamofire.request(currentpoiurl!).responseJSON { response in
////            let result = response.result
//            print("Esto es una prueba en la consola")
//            print(response.result.value!)
//            
//            
//        }
//        
//        completed()
//        
//        
//    }
    

}
