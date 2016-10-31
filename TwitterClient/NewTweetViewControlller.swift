//
//  NewTweetViewControlller.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/27/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class NewTweetViewControlller: UIViewController {

    var newTweet: Tweet? = nil
    var replyTweet: Tweet? = nil
    var currentUser: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dlog("tweet: \(replyTweet)")
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
        
        dlog("")
        dismiss(animated: true, completion: nil)

    }
    
}
