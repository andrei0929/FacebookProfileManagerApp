//
//  AppDelegate.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 3/25/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let navigationController: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UINavigationController") as! UINavigationController
        //user hasn't logged out
        if NSUserDefaults.standardUserDefaults().objectForKey("tokenString") != nil {
            //get access token stored locally
            FBSDKAccessToken.setCurrentAccessToken(FBSDKAccessToken(tokenString: NSUserDefaults.standardUserDefaults().objectForKey("tokenString")! as! String, permissions: NSUserDefaults.standardUserDefaults().arrayForKey("permissions")!, declinedPermissions: NSUserDefaults.standardUserDefaults().arrayForKey("declinedPermissions")!, appID: NSUserDefaults.standardUserDefaults().objectForKey("appID")! as! String, userID: NSUserDefaults.standardUserDefaults().objectForKey("userID")! as! String, expirationDate: NSUserDefaults.standardUserDefaults().objectForKey("expirationDate")! as! NSDate, refreshDate: NSUserDefaults.standardUserDefaults().objectForKey("refreshDate")! as! NSDate))
            //go directly to main screen
            navigationController.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainScreenController"), animated: false)
        }
        window?.rootViewController = navigationController
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
}

