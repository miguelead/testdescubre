//
//  PushNotificationService.swift
//  Nevula
//
//  Created by Momentum Lab 4 on 12/21/16.
//  Copyright © 2016 MomentumLab. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import AVFoundation
import Alamofire
import Firebase

/**
 Class containing all services related to the push notification
 */
class PushNotificationService {

    /**
    Event when a notification arrives and an associated action is executed
     - returns: Bool
     - parameter completion: Status in background download system of an element
     */
    class func notificationReceived(notification: [AnyHashable : Any], completion completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil, completionIOS10 completionHandler2: (() -> Void)? = nil){
        
        guard CurrentUser.shared != nil
            else {
                completionHandler?(.noData)
                completionHandler2?()
                return
        }
        if UIApplication.shared.applicationState == .active{
            AudioServicesPlayAlertSound(1007)
            NotificationCenter.default.post(.init(name: .onDidNewNotification))
        } else if UIApplication.shared.applicationState == .inactive{
            NotificationCenter.default.post(.init(name: .onDidRedirectNewNotification))
        } else{
            NotificationCenter.default.post(.init(name: .onDidNewNotification))
        }
        completionHandler?(.newData)
        completionHandler2?()
    }
    
    class func addPushConectionService(){
        guard let user = CurrentUser.shared ,
            let deviceToken = Messaging.messaging().fcmToken  else {
            return
        }
        let  ruta = KRutaMain + "/base/api/register/fcm/"
        let body = ["firebase_token": deviceToken,
                    "user_id": user._uid]
        Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            guard 200...300 ~= (response.response?.statusCode ?? -999) else {
                print("PushNotification Register fail")
                return
            }
            print("PushNotification sucessful")
        }
    }
    
    class func updateLocationDevice(lat: Double, long: Double){
        guard let user = CurrentUser.shared else {
                return
        }
        return
        let  ruta = KRutaMain + "/base/api/user/location"
        let body: [String : Any] = ["lat": lat, "long": long, "user_id": user._uid]
        Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            guard 200...300 ~= (response.response?.statusCode ?? -999) else {
                return
            }
      
        }
    }

    
}
