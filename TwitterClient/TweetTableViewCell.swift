//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/28/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

protocol TweetCellActionDelegate: class {
    
    func cellButtonPressed(cell: TweetTableViewCell, buttonIndex: Int) -> Void
    
}

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var replyButtonState = 0
    var retweetButtonState = 0
    var favButtonState = 0
    var indexPath: IndexPath!
    weak var delegate: TweetCellActionDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func replyButtonReleased(_ sender: AnyObject) {
        
        dlog("")
        
        //reply-action_0 -- gray, off
        //reply-action-pressed_0 -- light gray, pressed
        
        let img = UIImage(named: "reply-action_0")
        replyButton.setImage(img, for: UIControlState.normal)
        replyButtonState = 0
        
        delegate?.cellButtonPressed(cell: self, buttonIndex: 0)
    }

    
    @IBAction func replyButtonPressed(_ sender: AnyObject) {
       
        dlog("")
        
        //reply-action_0 -- gray, off
        //reply-action-pressed_0 -- light gray, pressed
        
        let img = UIImage(named: "reply-action-pressed_0")
        replyButton.setImage(img, for: UIControlState.normal)
        replyButtonState = 1
        
    }
    
    @IBAction func rewteetButtonPressed(_ sender: AnyObject) {
        dlog("")
        
        //retweet-action -- gray, off
        //rewteet-action-on -- green, on
        
        if retweetButtonState == 0 {
            retweetButtonState = 1
            let img = UIImage(named: "retweet-action-on")
            retweetButton.setImage(img, for: UIControlState.normal)
            
        }
        else {
            retweetButtonState = 0
            let img = UIImage(named: "retweet-action")
            retweetButton.setImage(img, for: UIControlState.normal)
        }
        delegate?.cellButtonPressed(cell: self, buttonIndex: 1)
    }
    
    @IBAction func favButtonPressed(_ sender: AnyObject) {
        
        dlog("")

        //like-action -- gray, off
        //like-action-on -- red, on
        
        if favButtonState == 0 {
            favButtonState = 1
            let img = UIImage(named: "like-action-on")
            favButton.setImage(img, for: UIControlState.normal)
        }
        else {
            favButtonState = 0
            let img = UIImage(named: "like-action")
            favButton.setImage(img, for: UIControlState.normal)
        }
        delegate?.cellButtonPressed(cell: self, buttonIndex: 2)
    }
    
    func configureCell(tweet: Tweet, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        //set to the opposite of what you want, then call pressed
        favButtonState = 1
        if let favorited = tweet.favorited {
            if favorited {
                favButtonState = 0
            }
        }
        favButtonPressed(self) //initial setting

        retweetButtonState = 1
        if let retweeted = tweet.retweeted {
            if retweeted {
                retweetButtonState = 0
            }
        }
        rewteetButtonPressed(self) //initial setting
        
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
