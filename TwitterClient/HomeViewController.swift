//
//  HomeViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/25/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    var timelineDownloadTask: URLSessionDataTask?
    var currentUser: User!
    var userTimeline: [Tweet] = [] {
        didSet {
            dlog("tweetCount: \(userTimeline.count)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentUser == nil {
            return
        }
        dlog("currentUSer: \(currentUser)")
        doTimelineDownload()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dlog("")
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dlog("")
        if currentUser == nil {
            signOutPressed(self)
            return
        }
        
        let isAuth = HttpTwitterClient.shared.isAuthorized
        dlog("isAuthorized: \(isAuth)")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dlog("")
        if let timelineDownloadTask = timelineDownloadTask {
            if timelineDownloadTask.state == .running {
                timelineDownloadTask.cancel()
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        dlog("")
    }

    @IBAction func newPressed(_ sender: AnyObject) {
        dlog("")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func doTimelineDownload() {
        
        let paramDict = ["count": 50]
        timelineDownloadTask = HttpTwitterClient.shared.fetchHomeTimeline(parameters: paramDict,
            success: { (tweetArray: [Tweet]) -> Void in
                
                if tweetArray.count > 0 {
                    self.userTimeline = tweetArray
                }
            },
            failure: { (error: Error) -> Void in
                dlog("error fetching timeline: \(error)")
        })
        
        dlog("task: \(timelineDownloadTask)")
    
    }
}
