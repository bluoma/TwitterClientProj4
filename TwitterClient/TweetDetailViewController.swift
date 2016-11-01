//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/27/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var tweetTableView: UITableView!
    var tweet: Tweet!
    var currentUser: User!
    var newTweet: Tweet? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dlog("parentVc: \(self.parent?.title)")
        
        dlog("tweet: \(tweet)")
        dlog("user: \(currentUser)")

        self.tweetTableView.tableFooterView = UIView()
        self.tweetTableView.estimatedRowHeight = 140.0
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dlog("new Tweet: \(newTweet)")
        NotificationCenter.default.addObserver(forName: userDidFavNotification, object: nil, queue: nil, using: didReceiveFavNotification)
        
        NotificationCenter.default.addObserver(forName: userDidFailFavNotification, object: nil, queue: nil, using: didReceiveFavFailNotification)
        
        NotificationCenter.default.addObserver(forName: userDidUnFavNotification, object: nil, queue: nil, using: didReceiveUnFavNotification)
        
        NotificationCenter.default.addObserver(forName: userDidFailUnFavNotification, object: nil, queue: nil, using: didReceiveUnFavFailNotification)
        
        NotificationCenter.default.addObserver(forName: userDidRetweetNotification, object: nil, queue: nil, using: didReceiveRetweetNotification)
        
        NotificationCenter.default.addObserver(forName: userDidFailRetweetNotification, object: nil, queue: nil, using: didReceiveRetweetFailNotification)
        
        NotificationCenter.default.addObserver(forName: userDidFailUnRetweetNotification, object: nil, queue: nil, using: didReceiveUnRetweetFailNotification)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dlog("")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dlog("")
        
        NotificationCenter.default.removeObserver(self)
    }
    



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dlog("segue: \(segue.identifier)")
        
        guard let segueName = segue.identifier else {
            return
        }

        dlog("made it")
        
        if segueName == "DetailToReplyModalSegue" {
            
            let navVc = segue.destination as! UINavigationController
            let newVc = navVc.topViewController as! NewTweetViewControlller
            newVc.replyTweet = tweet
            newVc.currentUser = currentUser
        }
    }
    
    //MARK: - Notification Handlers
    func didReceiveFavNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let tweet = info["tweet"] as? Tweet {
            
            tweet.favorited = true
            if let favCount = tweet.favoriteCount {
                tweet.favoriteCount = favCount + 1
            }
            else {
                tweet.favoriteCount = 0
            }
            tweetTableView.reloadData()
        }
    }
    
    func didReceiveFavFailNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let tweet = info["tweet"] as? Tweet {
            tweet.favorited = false
            tweetTableView.reloadData()
        }
    }
    
    
    func didReceiveUnFavNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let tweet = info["tweet"] as? Tweet {
            tweet.favorited = false
            if var favCount = tweet.favoriteCount {
                if favCount > 0 {
                    favCount -= 1
                }
                else {
                    favCount = 0
                }
                tweet.favoriteCount = favCount
            }
            tweetTableView.reloadData()
        }
    }
    
    func didReceiveUnFavFailNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let tweet = info["tweet"] as? Tweet {
            tweet.favorited = true
            tweetTableView.reloadData()
        }
    }
    
    
    func didReceiveRetweetNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let tweet = info["tweet"] as? Tweet {
            
            tweet.retweeted = true
            if let retweetCount = tweet.retweetCount {
                tweet.retweetCount = retweetCount + 1
            }
            else {
                tweet.retweetCount = 0
            }
            tweetTableView.reloadData()
        }
    }
    
    func didReceiveRetweetFailNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        if let info = notif.userInfo,
            let tweet = info["tweet"] as? Tweet {
            tweet.retweeted = false
            tweetTableView.reloadData()
        }
    }
    
    func didReceiveUnRetweetFailNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        if let info = notif.userInfo,
            let tweet = info["tweet"] as? Tweet {
            tweet.retweeted = true
            tweetTableView.reloadData()
        }
    }

    
    //MARK: - Actions
    @IBAction func replyPressed(_ sender: AnyObject) {
        
        dlog("")
        
        performSegue(withIdentifier: "DetailToReplyModalSegue", sender: self)
        
    }
}

extension TweetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        
        case 0:
            return UITableViewAutomaticDimension
            
        case 1:
            return 44.0
        
        case 2:
            return 44.0
            
        default:
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath)
        
        switch indexPath.row {
            
        case 0:
            let tweetCell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
            tweetCell.configureCell(tweet: self.tweet, indexPath: indexPath)
            
            return tweetCell
            
        case 1:
            let countsCell = tableView.dequeueReusableCell(withIdentifier: "DetailCountsTableViewCell", for: indexPath) as! DetailCountsTableViewCell
            countsCell.configureCell(tweet: self.tweet, indexPath: indexPath)
            
            return countsCell
            
        case 2:
            let actionCell = tableView.dequeueReusableCell(withIdentifier: "DetailActionsTableViewCell", for: indexPath) as! DetailActionsTableViewCell
            actionCell.configureCell(tweet: self.tweet, indexPath: indexPath)
            actionCell.delegate = self
            return actionCell
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dlog("indexPath: \(indexPath)")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
}

extension TweetDetailViewController: TweetActionDelegate {
    
    func cellButtonPressed(cell: TweetActionTableViewCell, buttonAction: TweetAction, buttonState: Int) {
        
        dlog("index: \(buttonAction) indexPath: \(cell.indexPath)")
        
        //let currentIndexPath = cell.indexPath!
        
        guard let tweetId = tweet.tweetId else {
            dlog("no id for tweet: \(tweet)")
            return
        }
        
        var notifDict: [String: Any] = [:]
        notifDict["tweet"] = tweet

        
        if buttonAction == .reply {
            replyPressed(tweet)  //reply
        }
        else if buttonAction == .retweet {
            //retweet
            //retweet
            let paramDict = ["id": tweetId]
            
            dlog("retweet buttonIndex: \(buttonAction), state: \(buttonState), retweetDict: \(paramDict)")
            
            
            if buttonState == 1 {
                
                cell.retweetButton.isEnabled = false //re-enabled when tableview redraws the cell
                let task = HttpTwitterClient.shared.retweetTweet(tweetId: tweetId, parameters: paramDict,
                    success: { (retweetedTweet: Tweet) in
                        dlog("retweetedTweet: \(retweetedTweet)")
                        NotificationCenter.default.post(name: userDidRetweetNotification, object: nil, userInfo: notifDict)
                    },
                    failure: { (error: Error) in
                        dlog("retweet error: \(error)")
                        NotificationCenter.default.post(name: userDidFailRetweetNotification, object: nil, userInfo: notifDict)
                    }
                )
                dlog("retweetTask: \(task)")
            }
            else {
                //not implemented
                dlog("unretweet not implemented")
                NotificationCenter.default.post(name: userDidFailUnRetweetNotification, object: nil, userInfo: notifDict)
            }
        }
        else if buttonAction == .fav {
            //fav
            let paramDict = ["id": tweetId]
            
            dlog("fav buttonIndex: \(buttonAction), state: \(buttonState), favDict: \(paramDict)")
            
            if buttonState == 1 {
                
                cell.favButton.isEnabled = false //re-enabled when tableview redraws the cell
                let task = HttpTwitterClient.shared.favTweet(parameters: paramDict,
                    success: { (favdTweet: Tweet) in
                        dlog("favdTweet: \(favdTweet)")
                        NotificationCenter.default.post(name: userDidFavNotification, object: nil, userInfo: notifDict)
                    },
                    failure: { (error: Error) in
                       dlog("fav error: \(error)")
                       NotificationCenter.default.post(name: userDidFailFavNotification, object: nil, userInfo: notifDict)
                    }
                )
                dlog("favTask: \(task)")
            }
            else {
                cell.favButton.isEnabled = false //re-enabled when tableview redraws the cell
                let task = HttpTwitterClient.shared.unFavTweet(parameters: paramDict,
                    success: { (favdTweet: Tweet) in
                        dlog("unfavdTweet: \(favdTweet)")
                        NotificationCenter.default.post(name: userDidUnFavNotification, object: nil, userInfo: notifDict)
                        
                    },
                    failure: { (error: Error) in
                        dlog("unfav error: \(error)")
                        NotificationCenter.default.post(name: userDidFailUnFavNotification, object: nil, userInfo: notifDict)
                    }
                )
                dlog("unFavTask: \(task)")
            }

        }
    }
}




