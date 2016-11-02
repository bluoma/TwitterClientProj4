//
//  HomeViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/25/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tweetsTableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var timelineDownloadTask: URLSessionDataTask?
    var currentUser: User? = User.currentUser
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
        
        refreshControl.addTarget(self, action: #selector(HomeViewController.doTimelineDownload), for: .valueChanged)
        
        if currentUser == nil {
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
            signOutPressed(self)
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
    
    func doTimelineDownload() {
        
        if timelineDownloadTask?.state == .running {
            
            dlog("task is running, ignore: \(timelineDownloadTask)")
            return
        }
        
        let paramDict = ["count": 50]
        timelineDownloadTask = HttpTwitterClient.shared.fetchHomeTimeline(parameters: paramDict,
            success: { (tweetArray: [Tweet]) -> Void in
                self.refreshControl.endRefreshing()
                if tweetArray.count > 0 {
                    self.userTimeline = tweetArray
                }
                self.doDownloadTweet(tweetId: "792846877129527296") //testing
            },
            failure: { (error: Error) -> Void in
                dlog("error fetching timeline: \(error)")
                self.refreshControl.endRefreshing()
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


extension HomeViewController: TweetActionDelegate {
    
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
            
            let paramDict = ["id": tweetId]

            dlog("reply buttonIndex: \(buttonAction), replyDict: \(paramDict)")

            newPressed(tweet)

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
