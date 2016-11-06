//
//  Tweet.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/26/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var createdAt: Date?
    var tweetId: String?
    var tweetText: String?
    var retweetCount: Int? = 0
    var favoriteCount: Int? = 0
    var retweeted: Bool? = false
    var favorited: Bool? = false
    var truncated: Bool? = false
    var tweetTextUrls: [NSDictionary]? = []
    var tweetTextHashtags: [NSDictionary]? = []
    var tweetTextUserMentions: [NSDictionary]? = []
    
    var creator: User?
    
    override init() {
        super.init()
    }
    
    convenience init(dictionary: NSDictionary) {
        
        self.init()
        
        tweetId = dictionary["id_str"] as? String
        tweetText = dictionary["text"] as? String
        
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        truncated = dictionary["truncated"] as? Bool
        tweetTextUrls = dictionary.value(forKeyPath: "entities.urls") as? [NSDictionary]
        tweetTextHashtags = dictionary.value(forKeyPath: "entities.hashtags") as? [NSDictionary]
        tweetTextUserMentions = dictionary.value(forKeyPath: "entities.user_mentions") as? [NSDictionary]

        //"Wed Oct 26 16:16:01 +0000 2016"
        if let createdAtString = dictionary["created_at"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = dateFormatter.date(from: createdAtString)
        }
        
        if let userDict = dictionary["user"] as? NSDictionary {
            creator = User(dictionary: userDict)
        }
        
    }
    
    
    class func tweetsWithArray(tweetDicts: [NSDictionary]) -> [Tweet] {
        
        var tweets: [Tweet] = []
        
        for tweetDict in tweetDicts {
            var tweet = Tweet(dictionary: tweetDict)
            //dlog("tweet: \(tweet)")
            tweets.append(tweet)
        }
        
        return tweets
    }
    
    
    class func profileTweetsWithArray(tweetDicts: [NSDictionary]) -> [Tweet] {
        
        var tweets: [Tweet] = []
        
        for tweetDict in tweetDicts {
            if let rtDict = tweetDict["retweeted_status"] as? NSDictionary {
                
                var tweet = Tweet(dictionary: rtDict)
                tweets.append(tweet)
            }
            else {
                var tweet = Tweet(dictionary: tweetDict)
            
                //dlog("tweet: \(tweet)")
                tweets.append(tweet)
            }
        }
        
        return tweets
    }

    
    override var description: String {
        return "id: \(tweetId), text: \(tweetText), createdAt: \(createdAt), retweets: \(retweetCount), favs: \(favoriteCount), creator: \(creator?.name), urls: \(tweetTextUrls), hashtags: \(tweetTextHashtags), mentions: \(tweetTextUserMentions)"
    }
    
    override var debugDescription: String {
        return "id: \(tweetId), text: \(tweetText), createdAt: \(createdAt), retweets: \(retweetCount), favs: \(favoriteCount), creator: \(creator?.name), urls: \(tweetTextUrls), hashtags: \(tweetTextHashtags), mentions: \(tweetTextUserMentions)"
    }
    

    
}


