//
//  MentionsViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 11/1/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class MentionsViewController: TimelineViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        dlog("in")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dlog("in")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dlog("in")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dlog("in")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dlog("in")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    //@IBAction override func menuPressed(_ sender: AnyObject) {
    //
    //    dlog("")
    //}

    override func didReceiveBeingReplyNotification(notif: Notification) -> Void {
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let tweet = info["tweet"] as? Tweet {
            
            newPressed(tweet)
        }
    }

    @IBAction func newPressed(_ sender: AnyObject) {
        dlog("")
        
        performSegue(withIdentifier: "MentionsNewTweetModalSegue", sender: sender)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        dlog("segue: \(segue.identifier)")
        
        guard let segueName = segue.identifier else {
            return
        }
        
        if segueName == "MentionsTweetDetailPushSegue" {
            
            guard let tweet = sender as? Tweet else {
                dlog("what!, no tweet")
                return
            }
            
            let destVc: TweetDetailViewController = segue.destination as! TweetDetailViewController
            
            destVc.tweet = tweet
            destVc.currentUser = currentUser
            newTweet = nil
            destVc.newTweet = newTweet
        }
        else if segueName == "MentionsNewTweetModalSegue" {
            
            let navVc = segue.destination as! UINavigationController
            let newVc = navVc.topViewController as! NewTweetViewControlller
            if let tweet = sender as? Tweet {
                newVc.replyTweet = tweet //reply
            }
            newVc.currentUser = currentUser
            newTweet = nil
            newVc.newTweet = newTweet
        }
    }
    
    override func doTimelineDownload() {
        
        if timelineDownloadTask?.state == .running {
            
            dlog("task is running, ignore: \(timelineDownloadTask)")
            self.refreshControl.endRefreshing()
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let paramDict = ["count": 50]
        timelineDownloadTask = HttpTwitterClient.shared.fetchMentionsTimeline(parameters: paramDict,
            success: { (tweetArray: [Tweet]) -> Void in
                self.refreshControl.endRefreshing()
                if tweetArray.count > 0 {
                    self.userTimeline = tweetArray
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
            },
            failure: { (error: Error) -> Void in
                dlog("error fetching timeline: \(error)")
                self.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
        dlog("task: \(timelineDownloadTask)")
    }
}

extension MentionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userTimeline.count
    }
    
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //    return 120.0
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionsTableViewCell", for: indexPath) as! TweetTableViewCell
        
        let tweet = userTimeline[indexPath.row]
        cell.delegate = self
        cell.configureCell(tweet: tweet, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dlog("indexPath: \(indexPath)")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tweet = userTimeline[indexPath.row]
        
        performSegue(withIdentifier: "MentionsTweetDetailPushSegue", sender: tweet)
        
        
    }
    
}

extension MentionsViewController: ProfileActionDelegate {
    
    func profileButtonPressed(cell: UITableViewCell, indexPath: IndexPath, buttonState: Int) -> Void {
        dlog("")
    }
    
}



