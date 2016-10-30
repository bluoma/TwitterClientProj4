//
//  DetailActionsTableViewCell.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/29/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class DetailActionsTableViewCell: UITableViewCell {

    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - actions
    
    @IBAction func replyButtonPressed(_ sender: AnyObject) {
        dlog("")
    }
    
    @IBAction func retweetButtonPressed(_ sender: AnyObject) {
        dlog("")
    }
    
    @IBAction func favButtonPressed(_ sender: AnyObject) {
        dlog("")
    }

    
    
}
