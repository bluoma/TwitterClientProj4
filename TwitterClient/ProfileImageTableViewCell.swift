//
//  ProfileImageTableViewCell.swift
//  TwitterClient
//
//  Created by Bill Luoma on 11/6/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescLabel: UILabel!
   
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
        if let imageUrlString = user.profileImageUrlString,
            let url: URL = URL(string: imageUrlString) {
            self.avatarImageView.setImageWith(url)
        }
        screenNameLabel.text = user.name
        userNameLabel.text = "@\(user.screenName!)"
        userDescLabel.text = user.desc
        if let bgImageUrlString = user.profileBackgroundImageUrlString,
            let url: URL = URL(string: bgImageUrlString) {
            let bgImageView = UIImageView()
            bgImageView.contentMode = .scaleAspectFill
            bgImageView.setImageWith(url)
            self.backgroundView = bgImageView
        }
    }
}
