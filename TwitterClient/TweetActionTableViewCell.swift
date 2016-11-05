//
//  TweetActionTableViewCell.swift
//  TwitterClient
//
//  Created by Bill Luoma on 11/1/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

enum TweetAction: String {
    case reply = "reply"
    case retweet = "retweet"
    case fav = "fav"
    
    // all known values
    public static let allValues = [reply, retweet, fav]
}

protocol TweetActionDelegate: class {
    
    func cellButtonPressed(cell: TweetActionTableViewCell, buttonAction: TweetAction, buttonState: Int) -> Void
    
}



class TweetActionTableViewCell: UITableViewCell {

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var replyButtonState = 0
    var retweetButtonState = 0
    var favButtonState = 0
    var indexPath: IndexPath!
    weak var delegate: TweetActionDelegate? = nil

    
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
        
        delegate?.cellButtonPressed(cell: self, buttonAction: .reply, buttonState: 1)
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
        
        if retweetButtonState == 0 {
            retweetButtonState = 1
        }
        else {
            retweetButtonState = 0
        }
        setImageForRetweetButtonState()
        delegate?.cellButtonPressed(cell: self, buttonAction: .retweet, buttonState: retweetButtonState)
    }
    
    func setImageForRetweetButtonState() {
        //retweet-action -- gray, off
        //rewteet-action-on -- green, on
        
        if retweetButtonState == 1 {
            let img = UIImage(named: "retweet-action-on")
            retweetButton.setImage(img, for: UIControlState.normal)
        }
        else {
            let img = UIImage(named: "retweet-action")
            retweetButton.setImage(img, for: UIControlState.normal)
        }
    }
    
    
    @IBAction func favButtonPressed(_ sender: AnyObject) {
        
        dlog("")
        if favButtonState == 0 {
            favButtonState = 1
        }
        else {
            favButtonState = 0
        }
        setImageForFavButtonState()
        delegate?.cellButtonPressed(cell: self, buttonAction: .fav, buttonState: favButtonState)
    }
    
    func setImageForFavButtonState() {
        //like-action -- gray, off
        //like-action-on -- red, on
        
        if favButtonState == 1 {
            let img = UIImage(named: "like-action-on")
            favButton.setImage(img, for: UIControlState.normal)
        }
        else {
            let img = UIImage(named: "like-action")
            favButton.setImage(img, for: UIControlState.normal)
        }
    }
    
    
    func configureCell(tweet: Tweet, indexPath: IndexPath) { }

    
}
