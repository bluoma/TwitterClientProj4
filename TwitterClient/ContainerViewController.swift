//
//  ContainerViewController.swift
//  TwitterClient
//
//  Created by Bill Luoma on 11/1/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    
    var contentViewLeadingMargin: CGFloat = 0.0
    var menuIsOpen: Bool = false
    var menuViewController: MenuViewController!
    
    var contentViewController: UIViewController! {
        
        didSet (oldViewController) {
            
            if oldViewController != nil {
                oldViewController.willMove(toParentViewController: nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            self.contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            closeMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dlog("in")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuViewController.delegate = self
        menuViewController.view.layoutIfNeeded()
        menuViewController.willMove(toParentViewController: self)
        addChildViewController(menuViewController)
        for childVc in menuViewController.viewControllers {
            addChildViewController(childVc)
        }
        self.view.insertSubview(self.menuViewController.view, belowSubview: self.contentView)
        menuViewController.didMove(toParentViewController: self)
        self.view.setNeedsLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dlog("in")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dlog("in")
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dlog("in")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dlog("in")
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
    
    
    //MARK: - Actions
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        let directionRight: Bool = velocity.x > 0
        
        //dlog("trans: \(translation), velocity: \(velocity), open: \(menuIsOpen)")
        
        if sender.state == .began {
            
            contentViewLeadingMargin = contentViewLeadingConstraint.constant
            
        }
        else if sender.state == .changed {
            if menuIsOpen && !directionRight {
                contentViewLeadingConstraint.constant = contentViewLeadingMargin + translation.x
            }
            else if !menuIsOpen && directionRight {
                contentViewLeadingConstraint.constant = contentViewLeadingMargin + translation.x
            }
        }
        else if sender.state == .ended {
            
            let options: UIViewAnimationOptions = directionRight ? .curveEaseOut : .curveEaseInOut
            
            UIView.animate(withDuration: 0.3, delay: 0, options: options,
                animations: { () -> Void in
                    if directionRight {
                        self.contentViewLeadingConstraint.constant = self.view.bounds.width - 72
                    }
                    else {
                        self.contentViewLeadingConstraint.constant = 0
                    }
                    self.view.layoutIfNeeded()

                },
                completion: { (done: Bool) -> Void in
                    if directionRight {
                        self.menuIsOpen = true
                    }
                    else {
                        self.menuIsOpen = false
                    }
            })
 
        }
        
    }
    
    func closeMenu() {
        if !menuIsOpen {
            return
        }
        let options: UIViewAnimationOptions = .curveEaseOut
        
        UIView.animate(withDuration: 0.3, delay: 0, options: options,
            animations: { () -> Void in
                self.contentViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
                        
            },
            completion: { (done: Bool) -> Void in
                self.menuIsOpen = false
        })

    }
    
}

extension ContainerViewController: MenuViewControllerDelegate {
    
    func menuDidSelectController(menu: MenuViewController, controller: UIViewController, at: Int) {
        
        self.contentViewController = controller

    }
}

