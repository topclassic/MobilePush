//
//  AppDelegate.swift
//  testiBeacon
//
//  Created by Digital-MacbookPro on 6/30/2559 BE.
//  Copyright © 2559 Digital-MacbookPro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    var kETAppID_Debug: String = "change_this_to_your_debug_appId"
    var kETAccessToken_Debug: String = "change_this_to_your_debug_accessToken"
    var kETAppID_Prod: String = "change_this_to_your_production_appId"
    var kETAccessToken_Prod: String = "change_this_to_your_production_accessToken"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        var successful: Bool = false
        //var error : NSError?
        
#if DEBUG
        ETPush.setETLoggerToRequiredState(true)
 
        successful =  ETPush.pushManager()!.configureSDKWithAppID(kETAppID_Debug,
                                           andAccessToken: kETAccessToken_Debug,
                                           withAnalytics: true,
                                           andLocationServices: false,
                                           andProximityServices: false,
                                           andCloudPages: false,
                                           withPIAnalytics: true,
                                           error: error)
    NSLog("1")
#else
    do{
        try ETPush.pushManager()!.configureSDKWithAppID(kETAccessToken_Debug,
                                                                     andAccessToken: kETAccessToken_Debug,
                                                                     withAnalytics: true,
                                                                     andLocationServices: false,
                                                                     andProximityServices: false,
                                                                     andCloudPages: false,
                                                                     withPIAnalytics: true)
    }catch let error as NSError{
         print("Error: \(error.domain)")
    }
    
        
    NSLog("2")
    
#endif
    NSLog("1")
        if (!successful) {
        } else {
        }
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge , .Sound], categories: nil)
        ETPush.pushManager()?.registerUserNotificationSettings(settings)
        ETPush.pushManager()?.registerForRemoteNotifications()
        ETLocationManager.sharedInstance().startWatchingLocation()
        ETRegion.retrieveGeofencesFromET()
        ETRegion.retrieveProximityFromET()
        ETPush.pushManager()?.applicationLaunchedWithOptions(launchOptions)
        ETPush.pushManager()?.addAttributeNamed("MyBooleanAttribute", value: "0")
        ETPush.getSDKState()
            
    
        return true

    }
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings){
        ETPush.pushManager()?.didRegisterUserNotificationSettings(notificationSettings)
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        ETPush.pushManager()?.registerDeviceToken(deviceToken)
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        ETPush.pushManager()?.applicationDidFailToRegisterForRemoteNotificationsWithError(error)
        ETAnalytics.trackPageView("data://applicationDidFailToRegisterForRemoteNotificationsWithError", andTitle: error.localizedDescription, andItem: nil, andSearch: nil)
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         ETLocationManager.sharedInstance().startWatchingLocation()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        ETLocationManager.sharedInstance().stopWatchingLocation()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        ETPush.pushManager()?.handleNotification(userInfo, forApplicationState: application.applicationState)
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        ETPush.pushManager()?.handleLocalNotification(notification)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        ETPush.pushManager()?.handleNotification(userInfo, forApplicationState: application.applicationState)
        
    }

}

