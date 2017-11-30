//
//  constants.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 14/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation
import CoreLocation


let kMaxKm = 50
let kLimitPag = 15
let KRuta = "http://192.168.0.101:8001"
let kRutaSecundaria = "http://192.168.0.101:8000"
let KRutaMain = "http://emprenomina.com"
//let KRutaMain = kRutaSecundaria
let kpolicyWebURL = "http://www.elcampitorefugio.org/terms-of-service"
let kTermWebURL = "http://www.elcampitorefugio.org/terms-of-service"

// Date keys
let kYesterdayTime = "Ayer"
let kSemiFullTime = "dd/MM HH:mm a"
let kSimpleTime = "yyyy-MM-dd"
let KOnlyTime = "HH:mm a"
let KOnlyTime2 = "HH:mm"
let kFullTime1 = "yyyy-MM-dd HH:mm:ss"
let kFullTime2 = "yyyy-MM-dd HH:mm"
let kFullTimeUTC1 = "yyyy-MM-dd'T'HH:mm:ss+00:00"
let kFullTimeUTC2 = "yyyy-MM-dd'T'HH:mm:ss'Z'"
let kFullTimeUTC3 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
let kAmericanFormat = "MMM dd, yyyy"


let defaultLocation = CLLocationCoordinate2D(latitude: 8.2972945, longitude: -62.7114469)

// Google Maps
let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
let apikey = "AIzaSyDiMXRRlAI8s5_vzRZknBiDUuukquzFWNI"


typealias DownloadComplete = () -> ()

