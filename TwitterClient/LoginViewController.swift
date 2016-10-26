//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/24/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        dlog("")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dlog("")
        NotificationCenter.default.addObserver(forName: didReceiveOauthTokenNotification, object: nil, queue: nil, using: oathTokenListener)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dlog("")
        NotificationCenter.default.removeObserver(self, name: didReceiveOauthTokenNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        dlog("segue: \(segue.identifier)")
        
        guard let segueName = segue.identifier else {
            alog("segue has no name")
            return;
        }
        
        if segueName == "LoginToHomeModalSegue" {
         
            let navVc = segue.destination as! UINavigationController
            let homeVc = navVc.topViewController as! HomeViewController
            homeVc.currentUser = sender as! User
        }
        
    }
    

    
    //MARK: - actions
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        dlog("")
        
        HttpTwitterClient.shared.login(
            success: { (accessToken: BDBOAuth1Credential?) in
                NotificationCenter.default.post(name: didReceiveOauthTokenNotification, object: accessToken)
                dlog("login success: \(accessToken?.token)")
            },
            failure: { (error: Error?) in
                dlog("login error: \(error)")
        })
    }

    
    func oathTokenListener(notification: Notification) -> Void {
        
        //dlog("notif: \(notification)")
        dlog("access token: \(oauthAccessToken)")
        
        let utask = HttpTwitterClient.shared.fetchCurrentUser(parameters: nil,
            success: { (user: User) -> Void in
                                                                
                self.performSegue(withIdentifier: "LoginToHomeModalSegue", sender: user)
                                    
            },
            failure: { (error: Error) -> Void in
                dlog("error getting current user: \(error)")
        })
        
        dlog("task: \(utask)")
    }
}

