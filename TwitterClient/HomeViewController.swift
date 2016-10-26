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
    
    override func viewDidLoad() {
        super.viewDidLoad()

         timelineDownloadTask = HttpTwitterClient.shared.fetchHomeTimeline(parameters: nil,
             success: { (task: URLSessionDataTask, tweetDictArray: Any?) -> Void in
         
                 dlog("data: \(tweetDictArray)")
         
             },
             failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                 dlog("error fetching timeline: \(error)")
         
         })
         
         dlog("task: \(timelineDownloadTask)")

    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dlog("")
       
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

}
