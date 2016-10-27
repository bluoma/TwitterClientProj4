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
    var userDict: NSDictionary?
    
    init(dictionary: NSDictionary) {
        
        userDict = dictionary
        userId = dictionary["id_str"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        desc = dictionary["description"] as? String
        profileImageUrlString = dictionary["profile_image_url_https"] as? String
        
    }
    
    private static var _currentUser: User?
    
    class var currentUser: User? {
        
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserDataKey") {
                    do {
                        let currentUserDict = try JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                        _currentUser = User(dictionary: currentUserDict)
                    }
                    catch let jerr as NSError {
                        dlog("json Error: \(jerr)")
                    }
                }
            }
            return _currentUser
        }
        
        set (user) {
            _currentUser = user
            let defaults = UserDefaults.standard

            if let user = user,
                let userDict = user.userDict {
                
                do {
                    let userData = try JSONSerialization.data(withJSONObject: userDict)
                    defaults.set(userData, forKey: "currentUserDataKey")
                }
                catch let jerr as NSError {
                    dlog("json Error: \(jerr)")
                    defaults.setNilValueForKey("currentUserDataKey")
                }
            }
            else {
                defaults.setNilValueForKey("currentUserDataKey")
            }
            defaults.synchronize()
            
        }
    }
    
    
    override var description: String {
        return "id: \(userId), name: \(name), screenName: \(screenName), desc: \(desc), imageUrl: \(profileImageUrlString)"
    }
    
    override var debugDescription: String {
         return "id: \(userId), name: \(name), screenName: \(screenName), desc: \(desc), imageUrl: \(profileImageUrlString)"
    }
    

}


