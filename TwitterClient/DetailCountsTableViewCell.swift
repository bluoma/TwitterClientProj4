//
//  DetailCountsTableViewCell.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/29/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class DetailCountsTableViewCell: UITableViewCell {

    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    
    var indexPath: IndexPath!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(tweet: Tweet, indexPath: IndexPath) {
        
        
        if let retreetCount = tweet.retweetCount {
            retweetCountLabel.text = "\(retreetCount)"
        }
        else {
            retweetCountLabel.text = ""
        }
        
        if let favCount = tweet.favoriteCount {
            favCountLabel.text = "\(favCount)"
        }
        else {
            favCountLabel.text = ""
        }

        
    }

}
