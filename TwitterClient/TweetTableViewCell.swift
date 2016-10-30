//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/28/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func replyButtonPressed(_ sender: AnyObject) {
        
        dlog("")
    }
    
    @IBAction func rewteetButtonPressed(_ sender: AnyObject) {
        dlog("")

    }
    
    @IBAction func favButtonPressed(_ sender: AnyObject) {
        
        dlog("")

    }
    
    func configureCell(tweet: Tweet, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        if let imageUrlString = tweet.creator?.profileImageUrlString,
            let imageUrl = URL(string: imageUrlString)
        
        {
            avatarImageView.setImageWith(imageUrl)
        }
        else {
            avatarImageView.image = nil
        }
        
        if let screenName = tweet.creator?.screenName {
            screenNameLabel.text = "@\(screenName)"
        }
        else {
            screenNameLabel.text = ""
        }
        
        if let fullname = tweet.creator?.name {
            userLabel.text = fullname
        }
        else {
            userLabel.text = ""
        }
        
        if let tweetDate = tweet.createdAt {
            timeLabel.text = tweetDate.description
        }
        else {
            timeLabel.text = ""
        }
        
        if let tweetText = tweet.tweetText {
            tweetLabel.text = tweetText
        }
        else {
            tweetLabel.text = ""
        }
        
    }

}
