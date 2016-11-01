//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/28/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit



class TweetTableViewCell: TweetActionTableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
    override func configureCell(tweet: Tweet, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        //on network call, button is disabled.
        //when network call is finished, tableview reloads the cell at this index path
        retweetButton.isEnabled = true
        retweetButtonState = 0
        if let retweeted = tweet.retweeted {
            if retweeted {
                retweetButtonState = 1
            }
        }
        setImageForRetweetButtonState()
        
        //on network call, button is disabled.
        //when network call is finished, tableview reloads the cell at this index path
        favButton.isEnabled = true
        favButtonState = 0
        if let favorited = tweet.favorited {
            if favorited {
                favButtonState = 1
            }
        }
        setImageForFavButtonState()
        
        replyButtonState = 0 //this is not a toggle button
        
        
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
            
            let diff = tweetDate.timeIntervalSinceNow
            //sec
            dlog("time: \(diff)")
            let intDiff = -Int(diff)
            
            if intDiff < 60 {
                timeLabel.text = "\(intDiff) sec"
            }
            else if intDiff < 3600 {
                let min = intDiff / 60
                timeLabel.text = "\(min) min"
            }
            else {
                let hrs = intDiff / (60 * 60)
                timeLabel.text = "\(hrs) hr"
            }
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
