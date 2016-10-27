//
//  AppDelegate.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/24/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let isAuth = HttpTwitterClient.shared.isAuthorized
        dlog("isAuthorized: \(isAuth)")
        
        if let user = User.currentUser {
            dlog("got a user: \(user)")
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let homeNavVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
            
            let homeVc = homeNavVC.topViewController as! HomeViewController
            homeVc.currentUser = user
            window?.rootViewController = homeNavVC
            window?.makeKeyAndVisible()
            
        }
        else {
            dlog("user is nil, loading login vc")
        }
        
        NotificationCenter.default.addObserver(forName: userDidLogoutNotification, object: nil, queue: nil, using: didLogoutListener)
        

        return true
    }
    
    func didLogoutListener(notification: Notification) -> Void {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryBoard.instantiateInitialViewController() as! LoginViewController
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        dlog("url: \(url)")
        let validUrl = HttpTwitterClient.shared.handleOpenUrl(url: url)
        return validUrl
    }
    
}





/*
 
 if let urlScheme = url.scheme,
 let urlQuery = url.query {
 
 if urlScheme == "btweeter" && urlQuery.contains("oauth_token") {
 
 validUrl = true
 
 let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
 for qcomp in components!.queryItems! {
 
 dlog("name: \(qcomp.name)")
 dlog("value: \(qcomp.value)")
 
 if qcomp.name == "oauth_token" {
 oauthAccessToken = qcomp.value
 NotificationCenter.default.post(name: didReceiveOauthTokenNotification, object: nil)
 }
 if qcomp.name == "oauth_verifier" {
 oauthVerifierToken = qcomp.value
 }
 }
 }
 }

 
 */
