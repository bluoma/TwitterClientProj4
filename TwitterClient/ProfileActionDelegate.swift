//
//  ProfileActionDelegate.swift
//  TwitterClient
//
//  Created by Bill Luoma on 11/3/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

protocol ProfileActionDelegate: class {
    
    func profileButtonPressed(cell: UITableViewCell, indexPath: IndexPath, buttonState: Int) -> Void
    
}
