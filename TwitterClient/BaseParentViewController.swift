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
    
    func toggleSwipeGesture(isOn: Bool)
}

class BaseParentViewController: UIViewController {

    weak var menuButtonDelegate: MenuButtonDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dlog("\(self.navigationItem.title) menuButtonDelegate: \(menuButtonDelegate)")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dlog("\(self.navigationItem.title) isRoot: \(isRootVc()), menuButtonDelegate: \(menuButtonDelegate)")
        if isRootVc() {
            menuButtonDelegate?.toggleSwipeGesture(isOn: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dlog("\(self.navigationItem.title) isRoot: \(isRootVc()), menuButtonDelegate: \(menuButtonDelegate)")
        if isRootVc() {
            menuButtonDelegate?.toggleSwipeGesture(isOn: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Actions
    @IBAction func menuPressed(_ sender: AnyObject) {
        dlog("\(self.navigationItem.title)")
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
    
    func isRootVc() -> Bool {
        
        var isRoot = false
        
        if let navVc = self.navigationController {
            
            let vcCount = navVc.viewControllers.count
            
            if vcCount > 0 && self === navVc.viewControllers[0] {
                isRoot = true
            }
        }
        return isRoot
    }

}
