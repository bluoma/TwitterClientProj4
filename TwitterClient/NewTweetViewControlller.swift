//
//  NewTweetViewControlller.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/27/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class NewTweetViewControlller: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetStatusTextView: UITextView!
    
    var newTweet: Tweet? = nil
    var replyTweet: Tweet? = nil
    var currentUser: User!
    var isReply = false
    var currentCreateTask: URLSessionDataTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let presenting = self.presentingViewController {
            dlog("presenting: \(presenting.title)")
            
            if let navVc = presenting as? UINavigationController,
                let topVc = navVc.topViewController {
                
                if let homeVc = topVc as? HomeViewController {
                    dlog("came from home: \(homeVc)")
                }
                else if let detailVc = topVc as? TweetDetailViewController {
                    dlog("came from detail: \(detailVc)")
                }
            }

        }
        dlog("tweet: \(replyTweet)")
        dlog("user: \(currentUser)")
        tweetStatusTextView.text = ""
        
        if replyTweet != nil {
            isReply = true
            self.title = "Reply"
            if let replyAtName = replyTweet?.creator?.screenName {
                
                tweetStatusTextView.text = "@\(replyAtName)"
            }
        }
        else {
            self.title = "New Tweet"
        }
        
        if let imageUrlString = currentUser.profileImageUrlString,
            let imageUrl = URL(string: imageUrlString)
            
        {
            avatarImageView.setImageWith(imageUrl)
        }
        else {
            avatarImageView.image = nil
        }
        
        if let screenName = currentUser.screenName {
            screenNameLabel.text = "@\(screenName)"
        }
        else {
            screenNameLabel.text = ""
        }
        
        if let fullname = currentUser.name {
            userNameLabel.text = fullname
        }
        else {
            userNameLabel.text = ""
        }

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
        dlog("newTweet: \(newTweet)")
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelPressed(_ sender: AnyObject) {
        
        dlog("")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tweetPressed(_ sender: AnyObject) {
        
        dlog("currentCreateTask: \(currentCreateTask)")
        
        if currentCreateTask?.state == .running {
            return
        }
        
        var paramDict: [String:String] = [:]
        paramDict["status"] = tweetStatusTextView.text
        if isReply {
            if let replyTweetId = replyTweet?.tweetId {
                paramDict["in_reply_to_status_id"] = replyTweetId
            }
        }
        
        currentCreateTask = HttpTwitterClient.shared.createTweet(parameters: paramDict,
            success: { (newTweet: Tweet) in
                dlog("createdTweet: \(newTweet)")
                self.newTweet = newTweet
                
                if let presenting = self.presentingViewController {
                    dlog("presenting: \(presenting.title)")
                    
                    if let navVc = presenting as? UINavigationController,
                        let topVc = navVc.topViewController {
                        
                        if let homeVc = topVc as? HomeViewController {
                            homeVc.newTweet = newTweet
                        }
                        else if let detailVc = topVc as? TweetDetailViewController {
                            detailVc.newTweet = newTweet
                        }
                    }
                }

                self.dismiss(animated: true, completion: nil)
            },
            failure: { (error: Error) in
                dlog("create tweet error: \(error)")
                                                            
        })

        

    }
    
}
