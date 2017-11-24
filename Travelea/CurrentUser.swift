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
    var _name: String
    var _mail: String
    var _userPhoto: URL?

    static var shared : CurrentUser?
    
    //ID,TITULO,TIPO,CAT1,DIRECCION,LAT,LON,PRECIO,RECOM_INDEX,CERCAN_INDEX,POPULAR_INDEX
    init(id: String, nombre: String, username: String, mail: String, photo: String, uid: String){
        _id = id
        _username = username
        _name = nombre
        _mail = mail
        _userPhoto = URL(string: photo)
        _uid = uid
    }
    
    init(user: User, customData: [String: Any] = [:]){
        _id = user.uid
        _username = user.displayName ?? ""
        _name = customData["name"] as? String ?? user.displayName ?? ""
        _mail = user.email ?? ""
        _userPhoto = user.photoURL
        _uid = customData["user_id"] as? String ?? ""
    }
}
