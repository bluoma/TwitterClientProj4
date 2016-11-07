//
//  ProfileStatsTableViewCell.swift
//  TwitterClient
//
//  Created by Bill Luoma on 11/6/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class ProfileStatsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(user: User) {
        
        dlog("user: \(user)")
        if let followerCount = user.followerCount {
            followerCountLabel.text = "\(followerCount)"
        }
        if let followingCount = user.followingCount {
            followingCountLabel.text = "\(followingCount)"
        }

    }

}
