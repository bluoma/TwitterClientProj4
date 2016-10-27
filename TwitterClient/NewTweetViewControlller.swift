//
//  NewTweetViewControlller.swift
//  TwitterClient
//
//  Created by Bill Luoma on 10/27/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class NewTweetViewControlller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelPressed(_ sender: AnyObject) {
        
        dlog("")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tweetPressed(_ sender: AnyObject) {
        
        dlog("")
        dismiss(animated: true, completion: nil)

    }
    
}
