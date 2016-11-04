//
//  DetailTableViewCell.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/29/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var retweetedByButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var tapRecognizer: UITapGestureRecognizer!
    var profileDelegate: ProfileActionDelegate? = nil
    var indexPath: IndexPath!
    var dateFormatter = DateFormatter() //"MM/dd/yy, h:mm a"  //01/29/14, 4:31 PM
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
        tapRecognizer = UITapGestureRecognizer(target: self,
                                               action: #selector(DetailTableViewCell.avatarPressed(_:)))
        avatarImageView.addGestureRecognizer(tapRecognizer)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - Actions
    
    
    @IBAction func retweetedByButtonPressed(_ sender: AnyObject) {
        
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
            userNameLabel.text = fullname
        }
        else {
            userNameLabel.text = ""
        }
        
        if let tweetDate = tweet.createdAt {
            
            dateLabel.text = dateFormatter.string(from: tweetDate)
        }
        else {
            dateLabel.text = ""
        }
        
        if let tweetText = tweet.tweetText {
            tweetTextLabel.text = tweetText
        }
        else {
            tweetTextLabel.text = ""
        }
        
    }

    @IBAction func avatarPressed(_ sender: AnyObject) {
        
        dlog("")
        profileDelegate?.profileButtonPressed(cell: self, indexPath: indexPath, buttonState: 1)
    }

    
}
