//
//  FacebookService.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/20/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

enum facebookPermissionStatus {
    case allPermission
}

enum facebookPermissionErrorStatus {
    case cancel
    case ErrorConexion
}

class FacebookLoginService {
    
    static func userIsFacebookLoggedIn() -> Bool{
        if FBSDKAccessToken.current() != nil{
            return true
        } else {
            return false
        }
    }
    
    static func getAccessToken() -> String{
        return FBSDKAccessToken.current().tokenString
    }
  
    static func getFacebookPermission(from view: UIViewController!, permissionEvent permissionGood: @escaping ((facebookPermissionStatus)-> Void), PermissionError: @escaping ((facebookPermissionErrorStatus)-> Void)){
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: view) { (result, error) -> Void in
            if error == nil, let result = result {
                if !result.isCancelled, result.grantedPermissions.contains("email"){
                    permissionGood(.allPermission)
                } else {
                    PermissionError(.cancel)
                }
            } else {
                PermissionError(.ErrorConexion)
            }
        }
    }
    
    static func getFacebookData(succesful goodEvent: @escaping (([String: Any])-> Void), error errorEvent: @escaping (()-> Void)){
        if FBSDKAccessToken.current() != nil{
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name,gender, picture.type(large), email, first_name, last_name"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil, let userData = result as? [String: Any]{
                    goodEvent(userData)
                } else{
                    errorEvent()
                }
            })
        } else {
            errorEvent()
        }
    }
}
