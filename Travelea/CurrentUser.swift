//
//  Usuario.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/15/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation
import Firebase



class CurrentUser {
    
    var _id: String
    var _uid: String
    var _username: String
<<<<<<< HEAD
    var _name: String
    var _mail: String
    var _userPhoto: URL?
=======
    var _mail: String
    var _userPhoto: URL?
    var _puntos:Int = 0
    var _checkIn:Int = 0
    var _guardados:Int = 0
>>>>>>> 3d1664f55821c5a8f0fecfeb21bfb71cac3418a6

    static var shared : CurrentUser?
    
    //ID,TITULO,TIPO,CAT1,DIRECCION,LAT,LON,PRECIO,RECOM_INDEX,CERCAN_INDEX,POPULAR_INDEX
<<<<<<< HEAD
    init(id: String, nombre: String, username: String, mail: String, photo: String, uid: String){
        _id = id
        _username = username
        _name = nombre
        _mail = mail
        _userPhoto = URL(string: photo)
        _uid = uid
=======
    init(id: String, username: String, mail: String, photo: String, uid: String, puntos:Int = 0, checkIn:Int = 0, guardados:Int = 0){
        _id = id
        _username = username
        _mail = mail
        _userPhoto = URL(string: photo)
        _uid = uid
        _puntos = puntos
        _checkIn = checkIn
        _guardados = guardados
>>>>>>> 3d1664f55821c5a8f0fecfeb21bfb71cac3418a6
    }
    
    init(user: User, customData: [String: Any] = [:]){
        _id = user.uid
        _username = user.displayName ?? ""
<<<<<<< HEAD
        _name = customData["name"] as? String ?? user.displayName ?? ""
        _mail = user.email ?? ""
        _userPhoto = user.photoURL
        _uid = customData["user_id"] as? String ?? ""
=======
        _mail = user.email ?? ""
        _userPhoto = user.photoURL
        _uid = customData["user_id"] as? String ?? ""
        _puntos = customData["puntos"] as? Int ?? 0
        _checkIn = customData["checkIn"] as? Int ?? 0
        _guardados = customData["guardados"] as? Int ?? 0
>>>>>>> 3d1664f55821c5a8f0fecfeb21bfb71cac3418a6
    }
}
