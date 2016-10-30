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
    
    var timelineDownloadTask: URLSessionDataTask?
    var currentUser: User!
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
        
        let emptyTweet = Tweet()
        //performSegue(withIdentifier: "NewTweetModalSegue", sender: emptyTweet)
        
        let pc = UIPrintInteractionController.shared
        
        pc.printingItem = UIImage(named: "twitter_start_bg")
            
        pc.present(animated: true) { (ctlr: UIPrintInteractionController, done: Bool, error: Error?) in
            
            dlog("bool param: \(done), error: \(error)")
        }
        
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        dlog("segue: \(segue)")
        
        guard let segueName = segue.identifier else {
            return
        }
        
        if segueName == "TweetDetailPushSegue" {
            let destVc: TweetDetailViewController = segue.destination as! TweetDetailViewController
            if let tweet = sender as? Tweet {
                destVc.tweet = tweet
            }
            
        }
    }
    

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



extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userTimeline.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        
        let tweet = userTimeline[indexPath.row]
        
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
