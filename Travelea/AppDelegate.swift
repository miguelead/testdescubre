//
//  AppDelegate.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 5/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FBSDKCoreKit
import UserNotifications
import IQKeyboardManagerSwift
import SwiftBackgroundLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var locationManager = TrackingHeadingLocationManager()
    var backgroundLocationManager = BackgroundLocationManager(regionConfig: RegionConfig(regionRadius: 200.0))


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        if let window = window, CurrentUser.shared != nil{
            self.registerForPushNotifications()
            self.setBackgroundManagerLocation()
            window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabMainController")
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handled
    }
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func setBackgroundManagerLocation(){
        locationManager.manager(for: .always, completion: { result in
            if case let .Success(manager) = result {
                manager.startUpdatingLocation(isHeadingEnabled: true) { result in
                    if case let .Success(locationHeading) = result, let location = locationHeading.location {
                        PushNotificationService.updateLocationDevice(lat: location.coordinate.latitude, long: location.coordinate.longitude)
                    }
                }
            }

        })
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func registerForPushNotifications() {

        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                }
            })
        } else {
            let type: UIUserNotificationType = [.badge, .alert, .sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func unregisterForPushNotifications(){
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let token = String(format: "%@", deviceToken as CVarArg)
        print("didRegisterForRemoteNotificationsWithDeviceToken", token)
        PushNotificationService.addPushConectionService()
    }
    

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let message = "didFailToRegisterForRemoteNotificationsWithError: " + error.localizedDescription
        print(message)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification fetchCompletionHandler")
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        PushNotificationService.notificationReceived(notification: userInfo, completion: completionHandler)
        completionHandler(UIBackgroundFetchResult.newData)

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        PushNotificationService.notificationReceived(notification: userInfo)
    }
    
   
    
    // MARK: - IOS 10 OR High Push notification method
    @objc(userNotificationCenter:willPresentNotification:withCompletionHandler:) @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    @objc(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:) @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceiveRemoteNotification fetchCompletionHandler")
        let userInfo = response.notification.request.content.userInfo
        PushNotificationService.notificationReceived(notification: userInfo, completionIOS10: completionHandler)
    }
    
}


extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        PushNotificationService.addPushConectionService()
    }
  
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}


