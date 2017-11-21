//
//  AppDelegate.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 5/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        if let window = window, CurrentUser.shared != nil{
            self.registerForPushNotifications()
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
        //PushNotificationService.shared.addPushConectionService(token: token)
    }
    

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let message = "didFailToRegisterForRemoteNotificationsWithError: " + error.localizedDescription
        print(message)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification fetchCompletionHandler")
        //PushNotificationService.shared.appState = application.applicationState
        //PushNotificationService.shared.notificationReceived(notification: userInfo, completion: completionHandler)
    }
    
    // MARK: - IOS 10 OR High Push notification method
    @objc(userNotificationCenter:willPresentNotification:withCompletionHandler:) @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("\(userInfo)")
        completionHandler(.alert)
    }
    
    @objc(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:) @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceiveRemoteNotification fetchCompletionHandler")
        //PushNotificationService.shared.appState = UIApplication.shared.applicationState
        _ = response.notification.request.content.userInfo
        //PushNotificationService.shared.notificationReceived(notification: userInfo, completionOS10: completionHandler)
        
    }
    
}
