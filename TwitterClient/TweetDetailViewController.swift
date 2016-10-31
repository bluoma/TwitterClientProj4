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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dlog("tweet: \(tweet)")
        dlog("user: \(currentUser)")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        dlog("")
        
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
            return 120.0
            
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

extension TweetDetailViewController: DetailCellActionDelegate {
    
    func cellButtonPressed(cell: DetailActionsTableViewCell, buttonIndex: Int) {
        
        dlog("index: \(buttonIndex) indexPath: \(cell.indexPath)")
        
        //let currentIndexPath = cell.indexPath!
        
        guard let tweetId = tweet.tweetId else {
            dlog("no id for tweet: \(tweet)")
            return
        }
        
        if buttonIndex == 0 {
            replyPressed(cell)  //reply
        }
        else if buttonIndex == 1 {
            //retweet
        }
        else if buttonIndex == 2 {
            //fav
            let paramDict = ["id": tweetId]
            
            dlog("fav buttonIndex: \(buttonIndex), favDict: \(paramDict)")
            tweet.favorited = true //assume it will succeed
            if let favCount = tweet.favoriteCount {
                tweet.favoriteCount = favCount + 1
            }
            cell.favButton.isEnabled = false
            let task = HttpTwitterClient.shared.favTweet(parameters: paramDict,
                success: { (favdTweet: Tweet) in
                    dlog("favdTweet: \(favdTweet)")
                    cell.favButton.isEnabled = true
                },
                failure: { (error: Error) in
                    dlog("error: \(error)")
                    self.tweet.favorited = false
                    if var favCount = self.tweet.favoriteCount {
                        if favCount > 0 {
                            favCount -= 1
                        }
                        else {
                            favCount = 0
                        }
                        self.tweet.favoriteCount = favCount
                    }
                    cell.favButton.isEnabled = true
                    cell.favButtonState = 0
                    cell.setImageForFavButtonState()
            })
            dlog("favTask: \(task)")

        }
    }
}




