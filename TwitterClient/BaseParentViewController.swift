//
//  BaseChildViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 11/2/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

protocol MenuButtonDelegate: class {
    
    func menuPressed(parentController: UIViewController)
}

class BaseParentViewController: UIViewController {

    weak var menuButtonDelegate: MenuButtonDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dlog("menuButtonDelegate: \(menuButtonDelegate)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Actions
    @IBAction func menuPressed(_ sender: AnyObject) {
        dlog("")
        menuButtonDelegate?.menuPressed(parentController: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
