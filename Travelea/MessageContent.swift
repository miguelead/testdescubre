//
//  MessageContent.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation

class MessageContent {
    
    var uid: String!
    var user_id: String!
    var mensaje:String = ""
    var usuario: String!
    var imagenUrl:String?
    var fechaEvento:String?
    var punto:String?
    var poi: String?
    var marker: Bool = false
    
    init(id: String, user_id: String, mensaje: String = "", usuario: String = "Desconocido", imagenUrl: String? = nil, punto:String? = nil, poi: String? = nil, marker: Bool = false, fecha: String? = nil) {
        
        self.uid = id
        self.user_id = user_id
        self.usuario = usuario
        self.mensaje = mensaje
        self.imagenUrl = imagenUrl
        self.punto = punto
        self.poi = poi
        self.marker = marker
        self.fechaEvento = fecha
    }
    
    init(id: String, data:[String: Any]?) {
        uid = id
        user_id = data?["user_id"] as? String ?? ""
        usuario = data?["user"] as? String ?? "Desconocido"
        mensaje = data?["text"] as? String ?? ""
        imagenUrl = data?["imagenUrl"] as? String
        fechaEvento = data?["date"] as? String
        punto = data?["punto_interes"] as? String
        marker = data?["favorite"] as? Bool ?? false
        poi = data?["poi"] as? String
    }
}
