//
//  LFRestaurentDetailsViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFRestaurentDetailsViewController: UIViewController,UIGestureRecognizerDelegate {
    @IBAction func settingBtnAction(_ sender: UIButton) {
        
//        let storyboard = UIStoryboard(name: "Main", bundlvarnil).instantiateViewController(withIdentifier: "LFItemDetailViewController")as? LFItemDetailViewController
//        self.navigationController?.pushViewController(storyboard!, animated: true)
        
    }

    @IBOutlet weak var animationView: UIView!
    var pageMenu : CAPSPageMenu?
    var tap: UITapGestureRecognizer?
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        
        tabViews()
      
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        //self.automaticallyAdjustsScrollViewInsets = false
        trayDownOffset = 10
        trayUp = animationView.center
        trayDown = CGPoint(x: animationView.center.x-340 ,y: animationView.center.y-50)
        
        // Configure the screen edges you want to detect.
      
        animationView.isUserInteractionEnabled = true
        animationView.addGestureRecognizer(panGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
   
    func didTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        // User tapped at the point above. Do something with that if you want.
    }
    func didScreenEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        // Do something when the user does a screen edge pan.
    }
   

    func didPan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)

        
        
        if sender.state == .began {
            trayOriginalCenter = animationView.center
            
            print("Gesture began")
        } else if sender.state == .changed {
            
            animationView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
            print("Gesture is changing")
        } else if sender.state == .ended {
            
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.animationView.center = self.trayDown
                    print("Moving Down")
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    //  self.uiView.center = self.trayUp
                    self.animationView.center = CGPoint(x: self.trayOriginalCenter.x, y: 145.833343505859)
                    
                    print("Moving up")
                }
            }
            print("Gesture ended")
        }
    }

    func tabViews(){
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1:LFPhotosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFPhotosViewController") as! LFPhotosViewController
        controller1.parantNavigationController = self.navigationController!
        controller1.title = "FOODIE PHOTOS"
        controllerArray.append(controller1)
        
        let controller2 : LFFavouriteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFFavouriteViewController") as! LFFavouriteViewController
        controller2.title = "ACCOUNT PHOTOS"
        controllerArray.append(controller2)
        
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorColor(UIColor.appTheamColor()),
            .selectedMenuItemLabelColor(UIColor.appTheamColor()),
            .menuHeight(40),
            .scrollMenuBackgroundColor(UIColor.white),
            .menuItemWidth(self.view.frame.size.width/2-16)
        ]
        
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.animationView.frame.width, height: self.animationView.frame.height), pageMenuOptions: parameters)
        
        self.animationView.addSubview((self.pageMenu?.view)!)
        
        //self.view.addSubview(View_DetailsView)
        
    }


}
