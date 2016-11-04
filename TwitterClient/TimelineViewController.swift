//
//  TimelineViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/25/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class TimelineViewController: BaseParentViewController {

    @IBOutlet weak var tweetsTableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var timelineDownloadTask: URLSessionDataTask?
    var currentUser: User! = User.currentUser
    var newTweet: Tweet?
    var userTimeline: [Tweet] = [] {
        didSet {
            dlog("tweetCount: \(userTimeline.count)")
            if userTimeline.count > 0 {
                tweetsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(TimelineViewController.doTimelineDownload), for: .valueChanged)
        
        if currentUser == nil {
            dlog("user is nil, bailing")
            NotificationCenter.default.post(name: userDidLogoutNotification, object: nil)
            return
        }
        dlog("currentUSer: \(currentUser)")
        self.tweetsTableView.addSubview(refreshControl)
        self.tweetsTableView.estimatedRowHeight = 120.0
        self.tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        doTimelineDownload()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dlog("")
        
        NotificationCenter.default.addObserver(forName: userDidBeginReplyNotification, object: nil, queue: nil, using: didReceiveBeingReplyNotification)
       
        NotificationCenter.default.addObserver(forName: userDidFavNotification, object: nil, queue: nil, using: didReceiveFavNotification)
        
        NotificationCenter.default.addObserver(forName: userDidFailFavNotification, object: nil, queue: nil, using: didReceiveFavFailNotification)
        
        NotificationCenter.default.addObserver(forName: userDidUnFavNotification, object: nil, queue: nil, using: didReceiveUnFavNotification)
        
        NotificationCenter.default.addObserver(forName: userDidFailUnFavNotification, object: nil, queue: nil, using: didReceiveUnFavFailNotification)
        
        NotificationCenter.default.addObserver(forName: userDidRetweetNotification, object: nil, queue: nil, using: didReceiveRetweetNotification)
        
        NotificationCenter.default.addObserver(forName: userDidFailRetweetNotification, object: nil, queue: nil, using: didReceiveRetweetFailNotification)
        
        NotificationCenter.default.addObserver(forName: userDidFailUnRetweetNotification, object: nil, queue: nil, using: didReceiveUnRetweetFailNotification)
        
        
        
        dlog("newEmptyTweet: \(self.newTweet)")
        
        if let newTweet = self.newTweet {
            if newTweet.tweetId != nil && newTweet.tweetId!.characters.count > 0 {
                self.userTimeline.insert(newTweet, at: 0)
                self.tweetsTableView.reloadData()
            }
        }
        else if userTimeline.count > 0 {
            tweetsTableView.reloadData()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dlog("")
        if currentUser == nil {
           
            return
        }
        
        let isAuth = HttpTwitterClient.shared.isAuthorized
        dlog("isAuthorized: \(isAuth)")
        
        NotificationCenter.default.removeObserver(self, name: userDidTweetNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dlog("")
        if let timelineDownloadTask = timelineDownloadTask {
            if timelineDownloadTask.state == .running {
                timelineDownloadTask.cancel()
            }
        }
        NotificationCenter.default.removeObserver(self)
        

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //listen while we're not visible
        NotificationCenter.default.addObserver(forName: userDidTweetNotification, object: nil, queue: nil, using: didReceiveTweetNotification)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Notification Handlers
    func didReceiveFavNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let indexPath = info["indexPath"] as? IndexPath,
            let tweet = info["tweet"] as? Tweet {
            
            tweet.favorited = true
            if let favCount = tweet.favoriteCount {
                tweet.favoriteCount = favCount + 1
            }
            else {
                tweet.favoriteCount = 0
            }
            tweetsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didReceiveFavFailNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let indexPath = info["indexPath"] as? IndexPath,
            let tweet = info["tweet"] as? Tweet {
            tweet.favorited = false
            tweetsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    
    func didReceiveUnFavNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let indexPath = info["indexPath"] as? IndexPath,
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
            tweetsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didReceiveUnFavFailNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let indexPath = info["indexPath"] as? IndexPath,
            let tweet = info["tweet"] as? Tweet {
            tweet.favorited = true
            tweetsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    
    func didReceiveRetweetNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let indexPath = info["indexPath"] as? IndexPath,
            let tweet = info["tweet"] as? Tweet {
            
            tweet.retweeted = true
            if let retweetCount = tweet.retweetCount {
                tweet.retweetCount = retweetCount + 1
            }
            else {
                tweet.retweetCount = 0
            }
            tweetsTableView.reloadRows(at: [indexPath], with: .none)
        }

    }

    func didReceiveRetweetFailNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        if let info = notif.userInfo,
            let indexPath = info["indexPath"] as? IndexPath,
            let tweet = info["tweet"] as? Tweet {
            tweet.retweeted = false
            tweetsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didReceiveUnRetweetFailNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        if let info = notif.userInfo,
            let indexPath = info["indexPath"] as? IndexPath,
            let tweet = info["tweet"] as? Tweet {
            tweet.retweeted = true
            tweetsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    
    func didReceiveTweetNotification(notif: Notification) -> Void {
        
        dlog("notif: \(notif)")
        
        if let info = notif.userInfo,
            let tweet = info["tweet"] as? Tweet {
           
            self.newTweet = tweet
        }
        
    }
    
    //override this
    func didReceiveBeingReplyNotification(notif: Notification) -> Void {
        dlog("notif: \(notif)")
    }
    
    //override this
    func doTimelineDownload() { }

}

extension TimelineViewController: TweetActionDelegate {
    
    func cellButtonPressed(cell: TweetActionTableViewCell, buttonAction: TweetAction, buttonState: Int) {
    
        //dlog("index: \(buttonIndex) indexPath: \(cell.indexPath)")
        
        let currentIndexPath = cell.indexPath!
        let tweet = userTimeline[currentIndexPath.row]
        guard let tweetId = tweet.tweetId else {
            dlog("no id for tweet: \(tweet)")
            return
        }
        
        var notifDict: [String: Any] = [:]
        notifDict["tweet"] = tweet
        notifDict["indexPath"] = currentIndexPath
        
        if buttonAction == .reply {
            
            dlog("reply buttonIndex: \(buttonAction)")
            NotificationCenter.default.post(name: userDidBeginReplyNotification, object: nil, userInfo: notifDict)

        }
        else if buttonAction == .retweet {
            //retweet
            let paramDict = ["id": tweetId]

            dlog("retweet buttonIndex: \(buttonAction), state: \(buttonState), retweetDict: \(paramDict)")

            
            if buttonState == 1 {
                
                cell.retweetButton.isEnabled = false //re-enabled when tableview redraws the cell
                let task = HttpTwitterClient.shared.retweetTweet(tweetId: tweetId, parameters: paramDict,
                    success: { (favdTweet: Tweet) in
                        dlog("retweetedTweet: \(favdTweet)")
                        NotificationCenter.default.post(name: userDidRetweetNotification, object: nil, userInfo: notifDict)
                    },
                    failure: { (error: Error) in
                        dlog("retweet error: \(error)")
                        NotificationCenter.default.post(name: userDidFailRetweetNotification, object: nil, userInfo: notifDict)
                })
                dlog("retweetTask: \(task)")
            }
            else {
                //not implemented
                dlog("unretweet not implemented")
                NotificationCenter.default.post(name: userDidFailUnRetweetNotification, object: nil, userInfo: notifDict)
            }
        }
        else if buttonAction == .fav {
            
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
                })
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
                })
                dlog("unFavTask: \(task)")
            }
        }
    }
}
