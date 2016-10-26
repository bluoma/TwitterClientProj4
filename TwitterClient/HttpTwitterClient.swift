//
//  HttpTwitterClient.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/25/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class HttpTwitterClient: BDBOAuth1SessionManager {
    
    static let shared = HttpTwitterClient(baseURL: twitterApiEndPointUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)!
    
    
    var onLoginSuccess: ((BDBOAuth1Credential?) -> Void)? = nil
    var onLoginFailure: ((Error?) -> Void)? = nil
    var failedToGetRequestToken = false
    
    func login(success: @escaping (BDBOAuth1Credential?) -> Void, failure: @escaping (Error?) -> Void) -> Void {
        
        onLoginSuccess = success
        onLoginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: twitterOauthRequestTokenPath, method: "GET", callbackURL: oauth1CallBackUrl, scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) -> Void in
                            
                dlog("requestToken: \(requestToken?.token)")
                            
                if let requestTokenString = requestToken?.token {
                                
                    if let authUrl = URL(string: "\(twitterAuthorizationUrl)?oauth_token=\(requestTokenString)") {
                        dlog("authUrl: \(authUrl)")
                        UIApplication.shared.open(authUrl)
                    }
                    else {
                        dlog("bad auth url")
                        let error = NSError(domain: "com.bluoma.TwitterClient", code: -25)
                        self.failedToGetRequestToken = true
                        self.onLoginFailure?(error)
                    }
                }
                else {
                    let error = NSError(domain: "com.bluoma.TwitterClient", code: -45)
                    self.onLoginFailure?(error)
                    self.failedToGetRequestToken = true
                    dlog("bad request token")
                }
            },
            failure: { (error: Error?) -> Void in
                dlog("error: \(error)")
                self.failedToGetRequestToken = true
                self.onLoginFailure?(error)
        })
    }
    
    func handleOpenUrl(url: URL) -> Bool {
        var validUrl = false
        
        if (failedToGetRequestToken) {
            dlog("we failed to get the request token, bailing")
            return validUrl
        }
        
        if let oauthCred = BDBOAuth1Credential(queryString: url.query) {
            dlog("oauthCred: \(oauthCred)")
            validUrl = true
            
            fetchAccessToken(withPath: twitterOauthAccessTokenPath, method: "POST", requestToken: oauthCred,
                success: { (accessToken: BDBOAuth1Credential?) in
                    oauthAccessToken = accessToken?.token
                    oauthVerifierToken = accessToken?.verifier
                    self.onLoginSuccess?(accessToken)
                    
                },
                failure: { (error: Error?) in
                    dlog("\(error)")
                    self.onLoginFailure?(error)
            })
        }
        else {
            let error = NSError(domain: "com.bluoma.TwitterClient", code: -35)
            self.onLoginFailure?(error)
        }
        return validUrl
    }
    
    func fetchHomeTimeline(parameters: Any?, success: @escaping (URLSessionDataTask, Any?) -> Void, failure: @escaping (URLSessionDataTask?, Error) -> Void) -> URLSessionDataTask? {
        
        let task: URLSessionDataTask? = HttpTwitterClient.shared.get(twitterHomeTimelinePath, parameters: parameters, progress: nil, success: success, failure: failure)
        
        return task
    }
    
    func fetchCurrentUser(parameters: Any?, success: @escaping (URLSessionDataTask, Any?) -> Void, failure: @escaping (URLSessionDataTask?, Error) -> Void) -> URLSessionDataTask? {
        
        let task: URLSessionDataTask? = HttpTwitterClient.shared.get(twitterCurrentUserPath, parameters: parameters, progress: nil, success: success, failure: failure)
        
        return task
    }

    
}
