//
//  File.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/24/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

//MARK: - dlog
func dlog(_ message: String, _ filePath: String = #file, _ functionName: String = #function, _ lineNum: Int = #line)
{
    #if DEBUG
        
        let url  = URL(fileURLWithPath: filePath)
        let path = url.lastPathComponent
        var fileName = "Unknown"
        if let name = path.characters.split(separator: ",").map(String.init).first {
            fileName = name
        }
        let logString = String(format: "%@.%@[%d]: %@", fileName, functionName, lineNum, message)
        NSLog(logString)
        
    #endif
    
}

//MARK: - alog
func alog(_ message: String, _ filePath: String = #file, _ functionName: String = #function, _ lineNum: Int = #line)
{
    let url  = URL(fileURLWithPath: filePath)
    let path = url.lastPathComponent
    var fileName = "Unknown"
    if let name = path.characters.split(separator: ",").map(String.init).first {
        fileName = name
    }
    let logString = String(format: "%@.%@[%d]: %@", fileName, functionName, lineNum, message)
    NSLog(logString)
}



func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

//MARK: - oauth1a

let twitterApiEndPointUrlString = "https://api.twitter.com"
let twitterApiEndPointUrl: URL = URL(string:twitterApiEndPointUrlString)!
let consumerKey = "52LAxu5pHerDedZznOe0pMfJ6"
let consumerSecret = "TzgDLpTTPvqPV9zezDZrsVY8lj4MyTsTMZl1vVtsiqIRGgld4m"
let oauth1CallBackUrl = URL(string: "btweeter://oauth")!

var oauthAccessToken: String? = nil
var oauthVerifierToken: String? = nil

let userDidLoginNotification = Notification.Name(rawValue: "userDidLoginNotification")
let userDidLogoutNotification = Notification.Name(rawValue: "userDidLogoutNotification")
let userDidFavNotification = Notification.Name(rawValue: "userDidFavNotification")
let userDidFailFavNotification = Notification.Name(rawValue: "userDidFailFavNotification")
let userDidUnFavNotification = Notification.Name(rawValue: "userDidUnFavNotification")
let userDidFailUnFavNotification = Notification.Name(rawValue: "userDidFailUnFavNotification")
let userDidRetweetNotification = Notification.Name(rawValue: "userDidRetweetNotification")
let userDidFailRetweetNotification = Notification.Name(rawValue: "userDidFailsRetweetNotification")
let userDidUnRetweetNotification = Notification.Name(rawValue: "userDidUnRetweetNotification")
let userDidFailUnRetweetNotification = Notification.Name(rawValue: "userDidFailUnRetweetNotification")
let userDidTweetNotification = Notification.Name(rawValue: "userDidTweetNotification")

let twitterAuthorizationUrl = "https://api.twitter.com/oauth/authorize"
let twitterOauthRequestTokenPath = "oauth/request_token"
let twitterOauthAccessTokenPath = "oauth/access_token"
let twitterCurrentUserPath = "1.1/account/verify_credentials.json"
let twitterHomeTimelinePath = "1.1/statuses/home_timeline.json"
let twitterUserDetailPath = "1.1/users/show.json"
let twitterTweetCreatePath = "1.1/statuses/update.json"
//POST https://api.twitter.com/1.1/statuses/retweet/243149503589400576.json?id=243149503589400576
let twitterTweetRetweetPath = "1.1/statuses/retweet/%@.json"
let twitterTweetDetailPath = "1.1/statuses/show.json"       //GET ?id=210462857140252672"
let twitterTweetFavPath = "1.1/favorites/create.json"      //POST ?id=243138128959913986"
let twitterTweetUnFavPath = "1.1/favorites/destroy.json"   //POST ?id=243138128959913986"


let twitterBlue = UIColor(red: 29, green: 161, blue: 242, alpha: 1.0)
