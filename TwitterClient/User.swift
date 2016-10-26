//
//  User.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/26/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class User: NSObject {

    
    var userId: String?
    var name: String?
    var screenName: String?
    var desc: String?
    var profileImageUrlString: String?
    
    
    init(dictionary: NSDictionary) {
        
        userId = dictionary["id_str"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        desc = dictionary["description"] as? String
        profileImageUrlString = dictionary["profile_image_url_https"] as? String
        
    }
    
    override var description: String {
        return "id: \(userId), name: \(name), screenName: \(screenName), desc: \(desc), imageUrl: \(profileImageUrlString)"
    }
    
    override var debugDescription: String {
         return "id: \(userId), name: \(name), screenName: \(screenName), desc: \(desc), imageUrl: \(profileImageUrlString)"
    }
    

}


/*
 
 {
	"id": 1565651,
	"id_str": "1565651",
	"name": "bill luoma",
	"screen_name": "bluoma",
	"location": "",
	"description": "author of Some Math from Kenning Editions",
	"url": null,
	"entities": {
 "description": {
 "urls": []
 }
	},
	"protected": true,
	"followers_count": 571,
	"friends_count": 1181,
	"listed_count": 18,
	"created_at": "Tue Mar 20 00:28:02 +0000 2007",
	"favourites_count": 1185,
	"utc_offset": -25200,
	"time_zone": "Pacific Time (US & Canada)",
	"geo_enabled": false,
	"verified": false,
	"statuses_count": 3758,
	"lang": "en",
	"status": {
 "created_at": "Sun Sep 11 23:52:22 +0000 2016",
 "id": 775119828973531136,
 "id_str": "775119828973531136",
 "text": "RT @outmouth: for whatecer reason, chunks of the WTC are on tour in coffin-like fashion. This one is at a park in my neighborhood. https:\/\/\u2026",
 "truncated": false,
 "entities": {
 "hashtags": [],
 "symbols": [],
 "user_mentions": [{
 "screen_name": "outmouth",
 "name": "Warlock Buffett",
 "id": 4785936140,
 "id_str": "4785936140",
 "indices": [3, 12]
 }],
 "urls": []
 },
 "source": "\u003ca href=\"http:\/\/twitter.com\/download\/android\" rel=\"nofollow\"\u003eTwitter for Android\u003c\/a\u003e",
 "in_reply_to_status_id": null,
 "in_reply_to_status_id_str": null,
 "in_reply_to_user_id": null,
 "in_reply_to_user_id_str": null,
 "in_reply_to_screen_name": null,
 "geo": null,
 "coordinates": null,
 "place": null,
 "contributors": null,
 "retweeted_status": {
 "created_at": "Sun Sep 11 20:31:49 +0000 2016",
 "id": 775069358762504192,
 "id_str": "775069358762504192",
 "text": "for whatecer reason, chunks of the WTC are on tour in coffin-like fashion. This one is at a park in my neighborhood. https:\/\/t.co\/FNq5BnXuIQ",
 "truncated": false,
 "entities": {
 "hashtags": [],
 "symbols": [],
 "user_mentions": [],
 "urls": [],
 "media": [{
 "id": 775069338818580480,
 "id_str": "775069338818580480",
 "indices": [117, 140],
 "media_url": "http:\/\/pbs.twimg.com\/media\/CsGZdQiUEAAYcCH.jpg",
 "media_url_https": "https:\/\/pbs.twimg.com\/media\/CsGZdQiUEAAYcCH.jpg",
 "url": "https:\/\/t.co\/FNq5BnXuIQ",
 "display_url": "pic.twitter.com\/FNq5BnXuIQ",
 "expanded_url": "https:\/\/twitter.com\/outmouth\/status\/775069358762504192\/photo\/1",
 "type": "photo",
 "sizes": {
 "medium": {
 "w": 955,
 "h": 1200,
 "resize": "fit"
 },
 "large": {
 "w": 1150,
 "h": 1445,
 "resize": "fit"
 },
 "thumb": {
 "w": 150,
 "h": 150,
 "resize": "crop"
 },
 "small": {
 "w": 541,
 "h": 680,
 "resize": "fit"
 }
 }
 }]
 },
 "extended_entities": {
 "media": [{
 "id": 775069338818580480,
 "id_str": "775069338818580480",
 "indices": [117, 140],
 "media_url": "http:\/\/pbs.twimg.com\/media\/CsGZdQiUEAAYcCH.jpg",
 "media_url_https": "https:\/\/pbs.twimg.com\/media\/CsGZdQiUEAAYcCH.jpg",
 "url": "https:\/\/t.co\/FNq5BnXuIQ",
 "display_url": "pic.twitter.com\/FNq5BnXuIQ",
 "expanded_url": "https:\/\/twitter.com\/outmouth\/status\/775069358762504192\/photo\/1",
 "type": "photo",
 "sizes": {
 "medium": {
 "w": 955,
 "h": 1200,
 "resize": "fit"
 },
 "large": {
 "w": 1150,
 "h": 1445,
 "resize": "fit"
 },
 "thumb": {
 "w": 150,
 "h": 150,
 "resize": "crop"
 },
 "small": {
 "w": 541,
 "h": 680,
 "resize": "fit"
 }
 }
 }]
 },
 "source": "\u003ca href=\"http:\/\/twitter.com\/download\/android\" rel=\"nofollow\"\u003eTwitter for Android\u003c\/a\u003e",
 "in_reply_to_status_id": null,
 "in_reply_to_status_id_str": null,
 "in_reply_to_user_id": null,
 "in_reply_to_user_id_str": null,
 "in_reply_to_screen_name": null,
 "geo": null,
 "coordinates": null,
 "place": null,
 "contributors": null,
 "is_quote_status": false,
 "retweet_count": 13,
 "favorite_count": 10,
 "favorited": false,
 "retweeted": true,
 "possibly_sensitive": false,
 "lang": "en"
 },
 "is_quote_status": false,
 "retweet_count": 13,
 "favorite_count": 0,
 "favorited": false,
 "retweeted": true,
 "lang": "en"
	},
	"contributors_enabled": false,
	"is_translator": false,
	"is_translation_enabled": false,
	"profile_background_color": "9AE4E8",
	"profile_background_image_url": "http:\/\/pbs.twimg.com\/profile_background_images\/366768761\/317533_10150457683173593_558603592_10372842_1856550997_n.jpg",
	"profile_background_image_url_https": "https:\/\/pbs.twimg.com\/profile_background_images\/366768761\/317533_10150457683173593_558603592_10372842_1856550997_n.jpg",
	"profile_background_tile": true,
	"profile_image_url": "http:\/\/pbs.twimg.com\/profile_images\/516974954382761984\/tad7zqQx_normal.jpeg",
	"profile_image_url_https": "https:\/\/pbs.twimg.com\/profile_images\/516974954382761984\/tad7zqQx_normal.jpeg",
	"profile_banner_url": "https:\/\/pbs.twimg.com\/profile_banners\/1565651\/1420819902",
	"profile_link_color": "0000FF",
	"profile_sidebar_border_color": "FFFFFF",
	"profile_sidebar_fill_color": "E0FF92",
	"profile_text_color": "000000",
	"profile_use_background_image": true,
	"has_extended_profile": false,
	"default_profile": false,
	"default_profile_image": false,
	"following": false,
	"follow_request_sent": false,
	"notifications": false,
	"translator_type": "none"
 }

 
 
 */
