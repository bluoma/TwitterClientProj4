//
//  HomeViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/25/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class HomeViewController: TimelineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dlog("")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dlog("")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dlog("")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    override func didReceiveBeingReplyNotification(notif: Notification) -> Void {
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let tweet = info["tweet"] as? Tweet {
            
            newPressed(tweet)
        }

    }


    
    //MARK: - Actions
    @IBAction func signOutPressed(_ sender: AnyObject) {
        
        HttpTwitterClient.shared.logout()
        
        //if let presenting = self.presentingViewController {
        //    dlog("presenting: \(presenting)")
        //    self.dismiss(animated: true, completion: nil)
        //}
        //else {  //we jumped here via 'autologin' and there's no loginVc backing us,
                //so tell the window to reload
                //from the root of the storyboard
            
            //dlog("no login vc behind us, reload")
        NotificationCenter.default.post(name: userDidLogoutNotification, object: nil)
        //}
        
    }
    
    //@IBAction override func menuPressed(_ sender: AnyObject) {
    //
    //    dlog("")
    //}

    @IBAction func newPressed(_ sender: AnyObject) {
        dlog("")
        
        performSegue(withIdentifier: "NewTweetModalSegue", sender: sender)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        dlog("segue: \(segue.identifier)")
        
        guard let segueName = segue.identifier else {
            return
        }
        
        
        if segueName == "TweetDetailPushSegue" {
            
            guard let tweet = sender as? Tweet else {
                dlog("what!, no tweet")
                return
            }
            
            let destVc: TweetDetailViewController = segue.destination as! TweetDetailViewController
            
            destVc.tweet = tweet
            destVc.currentUser = currentUser
            newTweet = nil
            destVc.newTweet = newTweet

            dlog("self.view.superview: \(self.view.superview?.tag)")
            dlog("self.navigationController.view.superview: \(self.navigationController?.view.superview?.tag)")

            
        }
        else if segueName == "NewTweetModalSegue" {
            
            let navVc = segue.destination as! UINavigationController
            let newVc = navVc.topViewController as! NewTweetViewControlller
            if let tweet = sender as? Tweet {
                newVc.replyTweet = tweet //reply
            }
            newVc.currentUser = currentUser
            newTweet = nil
            newVc.newTweet = newTweet
        }
        else if segueName == "HomeProfilePushSegue" {
            
            guard let tweet = sender as? Tweet else {
                dlog("what!, no tweet")
                return
            }

            
            if let user = tweet.creator {
                let destVc: ProfileViewController = segue.destination as! ProfileViewController

                destVc.user = user
                destVc.userIsCurrentUser = (user.userId == currentUser.userId)
            }
        }
    }
    
    func doDownloadTweet(tweetId: String) {
        
        let paramDict = ["id": tweetId]
        
        let tweetDownloadTask = HttpTwitterClient.shared.fetchTweet(parameters: paramDict,
            success: { (tweet: Tweet) -> Void in
                dlog("tweet: \(tweet)")
                self.userTimeline.insert(tweet, at: 0)
                self.tweetsTableView.reloadData()
                                                                            
            },
            failure: { (error: Error) -> Void in
                dlog("error fetching tweet: \(error)")
        })
        
        dlog("task: \(tweetDownloadTask)")

    }
    
    override func doTimelineDownload() {
        
        if timelineDownloadTask?.state == .running {
            
            dlog("task is running, ignore: \(timelineDownloadTask)")
            self.refreshControl.endRefreshing()
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let paramDict = ["count": 50]
        timelineDownloadTask = HttpTwitterClient.shared.fetchHomeTimeline(parameters: paramDict,
            success: { (tweetArray: [Tweet]) -> Void in
                self.refreshControl.endRefreshing()
                if tweetArray.count > 0 {
                    self.userTimeline = tweetArray
                }
                self.doDownloadTweet(tweetId: "792846877129527296") //testing
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            },
            failure: { (error: Error) -> Void in
                dlog("error fetching timeline: \(error)")
                self.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

        })
        
        dlog("task: \(timelineDownloadTask)")
    
    }
}



extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userTimeline.count
    }
    
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //    return 120.0
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        
        let tweet = userTimeline[indexPath.row]
        cell.delegate = self
        cell.profileDelegate = self
        cell.configureCell(tweet: tweet, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dlog("indexPath: \(indexPath)")
        
        tableView.deselectRow(at: indexPath, animated: true)

        let tweet = userTimeline[indexPath.row]

        performSegue(withIdentifier: "TweetDetailPushSegue", sender: tweet)
        
        
    }
    
}

extension HomeViewController: ProfileActionDelegate {
    
    func profileButtonPressed(cell: UITableViewCell, indexPath: IndexPath, buttonState: Int) -> Void {
        
        let tweet = userTimeline[indexPath.row]
        self.performSegue(withIdentifier: "HomeProfilePushSegue", sender: tweet)
        dlog("")
    }
    
}

