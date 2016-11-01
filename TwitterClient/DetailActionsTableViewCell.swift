//
//  DetailActionsTableViewCell.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/29/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit



class DetailActionsTableViewCell: TweetActionTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - actions
    
 
    
    override func configureCell(tweet: Tweet, indexPath: IndexPath) {
        dlog("")
        
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
        
    }
    
}
