//
//  MessageContent.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation

enum MessageType {
    case simple(Bool)
    case image(Bool)
    case board(Bool, PuntoDeInteresTablero)
    case checkIn(Bool)
    
    
}

class MessageContent {
    
    var uid: String!
    var user_id: String!
    var mensaje:String = ""
    var usuario: String!
    var imagenUrl:String?
    var fechaEvento:String?
    var punto:PuntoDeInteresTablero?
    var poi: String?
    var marker: Bool = false
    
    class func getType(body: MessageContent, id: String) -> MessageType{
        let flag = body.user_id == id
        if body.imagenUrl != nil{
            return .image(flag)
        } else
        if body.poi != nil{
            return .checkIn(flag)
        } else
        if let punto = body.punto{
            return .board(flag, punto)
        }
        return .simple(flag)
    }
    
    class func getFormatSeparator(list: [MessageContent], index:Int) -> (Bool, Bool){
        if !list.indices.contains(index-1), !list.indices.contains(index+1){
            return (true, false)
        } else if !list.indices.contains(index-1),list.indices.contains(index+1), list[index+1].user_id == list[index].user_id{
            return (true, false)
        } else if !list.indices.contains(index-1), list.indices.contains(index+1), list[index+1].user_id != list[index].user_id{
            return (true, true)
        } else if list.indices.contains(index-1), !list.indices.contains(index+1), list[index-1].user_id == list[index].user_id{
            return (false, false)
        } else if list.indices.contains(index-1), !list.indices.contains(index+1), list[index-1].user_id != list[index].user_id{
            return (true, false)
        } else if list.indices.contains(index-1), list.indices.contains(index+1), list[index-1].user_id == list[index].user_id, list[index-1].user_id == list[index].user_id{
            return (false, false)
        } else if list.indices.contains(index-1), list.indices.contains(index+1), list[index-1].user_id == list[index].user_id, list[index-1].user_id != list[index].user_id{
            return (false, true)
        } else if list.indices.contains(index-1), list.indices.contains(index+1), list[index-1].user_id != list[index].user_id, list[index-1].user_id == list[index].user_id{
            return (true, false)
        } else{
            return (true, true)
        }
    }
    
    init(id: String, user_id: String, mensaje: String = "", usuario: String = "Desconocido", imagenUrl: String? = nil, punto:PuntoDeInteresTablero? = nil, poi: String? = nil, marker: Bool = false, fecha: String? = nil) {
        
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
        punto = data?["punto_interes"] as? PuntoDeInteresTablero
        marker = data?["favorite"] as? Bool ?? false
        poi = data?["poi"] as? String
    }
}
