//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 11/1/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

//can be a root vc or a pushed child, checking isRootVc() will tell
class ProfileViewController: TimelineViewController {

    var user: User? = nil
    var userIsCurrentUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dlog("in userIsCurrentUser: \(userIsCurrentUser), user: \(user)")

        if isRootVc() {
            self.user = User.currentUser
            self.userIsCurrentUser = true
            self.navigationItem.title = "My Profile"
        }
        else {
            self.navigationItem.leftBarButtonItem = nil //show the back button instead
            self.navigationItem.hidesBackButton = false
            if let screenName = user?.screenName {
                self.navigationItem.title = "@\(screenName) Profile"
            }
        }

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
    //    dlog("")
    //}


    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueName = segue.identifier {
            
            if segueName == "ProfileTweetDetailPushSegue" {
                
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

            
            
        }
        
        
    }
    
    
    override func doTimelineDownload() {
        
        if timelineDownloadTask?.state == .running {
            
            dlog("task is running, ignore: \(timelineDownloadTask)")
            self.refreshControl.endRefreshing()
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var paramDict: [String: Any] = ["count": 50]
        paramDict["include_rts"] = true
        paramDict["exclude_replies"] = false
        if let userId = user?.userId {
            paramDict["user_id"] = userId
        }
        
        dlog("params: \(paramDict)")
        
        timelineDownloadTask = HttpTwitterClient.shared.fetchUserTimeline(parameters: paramDict,
            success: { (tweetArray: [Tweet]) -> Void in
                self.refreshControl.endRefreshing()
                if tweetArray.count > 0 {
                    self.userTimeline = tweetArray
                }
                                                                           
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

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        else {
            return userTimeline.count
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                return 44.0
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "")
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let icell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageTableViewCell", for: indexPath) as! ProfileImageTableViewCell
                icell.configureCell(user: user!)
                cell = icell
            }
            else {
                let icell = tableView.dequeueReusableCell(withIdentifier: "ProfileStatsTableViewCell", for: indexPath) as! ProfileStatsTableViewCell
                icell.configureCell(user: user!)
                cell = icell
            }
        }
        else {
            let pcell = tableView.dequeueReusableCell(withIdentifier: "ProfileTweetTableViewCell", for: indexPath) as! TweetTableViewCell
            
            let tweet = userTimeline[indexPath.row]
            pcell.delegate = self
            pcell.profileDelegate = self
            pcell.configureCell(tweet: tweet, indexPath: indexPath)
            cell = pcell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dlog("indexPath: \(indexPath)")
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let tweet = userTimeline[indexPath.row]
            performSegue(withIdentifier: "ProfileTweetDetailPushSegue", sender: tweet)
        }
    }
    
}

extension ProfileViewController: ProfileActionDelegate {
    
    func profileButtonPressed(cell: UITableViewCell, indexPath: IndexPath, buttonState: Int) -> Void {
        
        let tweet = userTimeline[indexPath.row]
        
        //self.performSegue(withIdentifier: "HomeProfilePushSegue", sender: tweet)
        
        if let tuser = tweet.creator {
            if tuser.userId != self.user?.userId {
            
            let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVc: ProfileViewController = sb.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profileVc.user = tuser
            profileVc.userIsCurrentUser = (tuser.userId == currentUser.userId)
            
            self.navigationController?.pushViewController(profileVc, animated: true)
            }
            else {
                dlog("curr profile to curr profile not supported")
            }
        }
        else {
            dlog("no tweet user, not supported")
        }
    }
    
}

