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
    
    
    func fetchHomeTimeline(parameters: Any?, success: @escaping (URLSessionDataTask, Any?) -> Void, failure: @escaping (URLSessionDataTask?, Error) -> Void) -> URLSessionDataTask? {
        
        let task: URLSessionDataTask? = HttpTwitterClient.shared.get(twitterHomeTimelinePath, parameters: parameters, progress: nil, success: success, failure: failure)
        
        return task
    }
    
    func fetchCurrentUser(parameters: Any?, success: @escaping (URLSessionDataTask, Any?) -> Void, failure: @escaping (URLSessionDataTask?, Error) -> Void) -> URLSessionDataTask? {
        
        let task: URLSessionDataTask? = HttpTwitterClient.shared.get(twitterCurrentUserPath, parameters: parameters, progress: nil, success: success, failure: failure)
        
        return task
    }

    
}
