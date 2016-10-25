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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        dlog("")
        
        let baseUrl = URL(string: "https://api.twitter.com")
    
        let twitterClient = BDBOAuth1SessionManager(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: oauth1CallBackUrl, scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) -> Void in
                                            
                dlog("requestToken: \(requestToken?.token)")
                
                if let requestTokenString = requestToken?.token {
                
                    if let authUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestTokenString)") {
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
        
    }
    
}

