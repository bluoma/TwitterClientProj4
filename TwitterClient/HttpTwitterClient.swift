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
    
    func fetchCurrentUser(parameters: Any?, success: @escaping (User) -> Void, failure: @escaping (Error) -> Void) -> URLSessionDataTask? {
        
        return HttpTwitterClient.shared.get(twitterCurrentUserPath, parameters: parameters, progress: nil,
            success: { (task: URLSessionDataTask, userDict: Any?) -> Void in
                
                if let userDict = userDict as? NSDictionary {
                    let user = User(dictionary: userDict)
                    if user.userId != nil {
                        dlog("user: \(user.userId)")
                        success(user)
                    }
                    else {
                        let error = NSError(domain: "com.bluoma.TwitterClient", code: -115)
                        failure(error)
                    }
                }
                else {
                    let errDict = ["localizedDescription": "Can not convert Any? to NSDictionary"]
                    let error = NSError(domain: "com.bluoma.TwitterClient", code: -105, userInfo: errDict)
                    failure(error)
                }
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                dlog("error getting current user: \(error)")
                dlog("response: \(task?.response)")
                failure(error)
                
        })
    }
    
    func fetchHomeTimeline(parameters: Any?, success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) -> URLSessionDataTask? {
        
        return HttpTwitterClient.shared.get(twitterHomeTimelinePath, parameters: parameters, progress: nil,
            success: { (task: URLSessionDataTask, tweetDictArray: Any?) -> Void in
                if let tweetDictArray = tweetDictArray as? [NSDictionary] {
                    let tweetArray: [Tweet] = Tweet.tweetsWithArray(tweetDicts: tweetDictArray)
                    success(tweetArray)
                }
                else {
                    let errDict = ["localizedDescription": "Can not convert Any? to [NSDictionary]"]
                    let error = NSError(domain: "com.bluoma.TwitterClient", code: -205, userInfo: errDict)
                    failure(error)
                }
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                dlog("error getting user timeline: \(error)")
                dlog("response: \(task?.response)")
                failure(error)
        })
    }

    
}
