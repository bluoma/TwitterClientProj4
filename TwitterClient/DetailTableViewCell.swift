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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - Actions
    
    
    @IBAction func retweetedByButtonPressed(_ sender: AnyObject) {
        
        dlog("")
    }
    
    
    
}
