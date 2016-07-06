//
//  AppDelegate.swift
//  testiBeacon
//
//  Created by Digital-MacbookPro on 6/30/2559 BE.
//  Copyright © 2559 Digital-MacbookPro. All rights reserved.
//

import UIKit
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var window: UIWindow?
    var kETAppID_Debug: String = "fe33ce02-918e-402d-9a3b-9caa6fc5299b"
    var kETAccessToken_Debug: String = "622qbc9ey45nk2jypa275gcw"
    var kETAppID_Prod: String = "fe33ce02-918e-402d-9a3b-9caa6fc5299b"
    var kETAccessToken_Prod: String = "622qbc9ey45nk2jypa275gcw"
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        var successful: Bool = false

        //var error : NSError?
        
#if DEBUG
        ETPush.setETLoggerToRequiredState(true)
        successful = false
        do {
            try ETPush.pushManager()?.configureSDKWithAppID(kETAppID_Debug,
                                                        andAccessToken: kETAccessToken_Debug,
                                                        withAnalytics: true,
                                                        andLocationServices: true,
                                                        andProximityServices: false,
                                                        andCloudPages: true,
                                                        withPIAnalytics: true)
        } catch let error as NSError {
            NSLog("Error 2: \(error)")
        }
        NSLog("0")
#else
        ETPush.setETLoggerToRequiredState(true)
        successful = true
        do {
            try ETPush.pushManager()!.configureSDKWithAppID(kETAppID_Debug,
                                                            andAccessToken: kETAccessToken_Debug,
                                                            withAnalytics: true,
                                                            andLocationServices: true,
                                                            andProximityServices: false,
                                                            andCloudPages: true,
                                                            withPIAnalytics: true)
        } catch let error as NSError {
            NSLog("Error2: \(error)")
        }
        NSLog("1")
#endif
        
        if (successful == false) {
            //print("3")
        } else {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge , .Sound], categories: nil)
            ETPush.pushManager()?.registerUserNotificationSettings(settings)
            ETPush.pushManager()?.registerForRemoteNotifications()
           // ETLocationManager.sharedInstance().startWatchingLocation()
            ETRegion.retrieveGeofencesFromET()
            ETRegion.retrieveProximityFromET()
            ETPush.pushManager()?.applicationLaunchedWithOptions(launchOptions)
            ETPush.pushManager()?.addAttributeNamed("MyBooleanAttribute", value: "0")
            ETPush.getSDKState()
            askUserToOpenLocationServices()
            print("4")
        }

        return true

    }
    func askUserToOpenLocationServices(){
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        }
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
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
