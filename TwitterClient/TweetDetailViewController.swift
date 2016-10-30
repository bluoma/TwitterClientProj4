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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dlog("tweet: \(tweet)")
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func replyPressed(_ sender: AnyObject) {
        
        dlog("")
        
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

