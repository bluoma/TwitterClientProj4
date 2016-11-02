//
//  MenuViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 11/1/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate {
    
    func menuDidSelectController(menu: MenuViewController, controller: UIViewController, at: Int)
    
}

class MenuViewController: UIViewController {

    
    @IBOutlet weak var menuTableView: UITableView!
    
    var viewControllers: [UIViewController] = []
    var delegate: MenuViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dlog("in tableView: \(menuTableView)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeNavVc = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
        
         let mentionsNavVc = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController") as! UINavigationController
        
         let profileNavVc = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController
        
        viewControllers.append(homeNavVc)
        viewControllers.append(mentionsNavVc)
        viewControllers.append(profileNavVc)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dlog("in")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dlog("in")
        menuTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dlog("in")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dlog("")
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

}


extension MenuViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        dlog("indexPath.row: \(indexPath.row)")

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Home"
        }
        else if indexPath.row == 1 {
            cell.textLabel?.text = "Mentions"
        }
        else if indexPath.row == 2 {
            cell.textLabel?.text = "Profile"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        dlog("indexPath.row: \(indexPath.row)")
        
        delegate?.menuDidSelectController(menu: self, controller: viewControllers[indexPath.row], at: indexPath.row)

    }
    
}
