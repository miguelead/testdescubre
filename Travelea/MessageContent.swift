//
//  MessageContent.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation

class MessageContent {
    
    var uid:String!
    var user_id:String!
    var mensaje:String = ""
    var usuario: String!
    var imagenUrl:String?
    var fechaEvento:String?
    var punto:PuntoDeInteres?
    var poi: String?
    var marker: Bool = false
    
    init(uid: String, user_id: String, mensaje: String = "", usuario: String = "Desconocido", imagenUrl: String? = nil, punto:PuntoDeInteres? = nil, poi: String? = nil, marker: Bool = false, fecha: String? = nil) {
        self.uid = uid
        self.user_id = user_id
        self.usuario = usuario
        self.mensaje = mensaje
        self.imagenUrl = imagenUrl
        self.punto = punto
        self.poi = poi
        self.marker = marker
        self.fechaEvento = fecha
    }
}
