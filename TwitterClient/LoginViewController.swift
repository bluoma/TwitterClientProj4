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
            
        }
        
    }
    

    
    //MARK: - actions
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        dlog("")
        
        HttpTwitterClient.shared.deauthorize()
        HttpTwitterClient.shared.fetchRequestToken(withPath: twitterOauthRequestTokenPath, method: "GET", callbackURL: oauth1CallBackUrl, scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) -> Void in
                                            
                dlog("requestToken: \(requestToken?.token)")
                
                if let requestTokenString = requestToken?.token {
                
                    if let authUrl = URL(string: "\(twitterAuthorizationUrl)?oauth_token=\(requestTokenString)") {
                        dlog("authUrl: \(authUrl)")
                        UIApplication.shared.open(authUrl)
                    }
                    else {
                        dlog("bad auth url")
                    }
                }
                else {
                    dlog("bad request token")
                }
            },
            failure: { (error: Error?) -> Void in
                dlog("error: \(error)")
        })
    }

    
    func oathTokenListener(notification:Notification) -> Void {
        
        dlog("notif: \(notification)")
        dlog("token: \(oauthAccessToken)")
        
        let utask = HttpTwitterClient.shared.fetchCurrentUser(parameters: nil,
            success: { (task: URLSessionDataTask, userDict: Any?) -> Void in
                                                                
                dlog("userDict: \(userDict)")
                
                self.performSegue(withIdentifier: "LoginToHomeModalSegue", sender: self)

                if let userDict = userDict as? NSDictionary {
                    
                    let user = User(dictionary: userDict)
                    
                    dlog("user: \(user)")
                }
                
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                dlog("error getting current user: \(error)")
                                                                
        })
        
        dlog("task: \(utask)")
        
    }
    
}

