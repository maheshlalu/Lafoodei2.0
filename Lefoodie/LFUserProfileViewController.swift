
//
//  LFUserProfileViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 03/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
//import MDCParallaxView
class LFUserProfileViewController: UIViewController,UIGestureRecognizerDelegate,UIScrollViewDelegate {
    @IBAction func settingBtnAction(_ sender: UIButton) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFProfileSettingViewController")as! LFProfileSettingViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    @IBOutlet weak var Scroller_ScrollerView: UIScrollView!
    @IBOutlet weak var View_DetailsView: UIView!
    @IBOutlet weak var uiView: UIView!
    var pageMenu : CAPSPageMenu?
    var tap: UITapGestureRecognizer?
    @IBOutlet weak var tableView: UITableView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        print(gestureRecognizer.location(in: self.view))
     if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)

            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
 
        }
    }
    
    
    @IBAction func BTN_Tapping(_ sender: UITapGestureRecognizer) {
        
        
    }
    
    func didTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        // User tapped at the point above. Do something with that if you want.
    }
    
    func didPan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            trayOriginalCenter = uiView.center
            
            //  print("Gesture began")
        } else if sender.state == .changed {
            
            uiView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
             print(CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y))
            
            print("Gesture is changing")
        } else if sender.state == .ended {
            UIView.transition(with: self.uiView, duration: 0.3, options: UIViewAnimationOptions.curveLinear, animations: {
                
                if velocity.y > 0 {
                    
                    
                    // UIView.animate(withDuration: 0.3) {
                    if UIScreen.main.bounds.size.width == 320
                    {
                        self.uiView.center = CGPoint(x: self.trayOriginalCenter.x, y: 544.0)
                    }else if UIScreen.main.bounds.size.width == 375
                    {
                        self.uiView.center = CGPoint(x: self.trayOriginalCenter.x, y: 592.0)
                    }else if UIScreen.main.bounds.size.width == 414
                    {
                        self.uiView.center = CGPoint(x: self.trayOriginalCenter.x, y:  646.0)
                        
                    }
                    
                    
                     print(CGPoint(x: self.trayOriginalCenter.x, y: self.trayOriginalCenter.y))
                    
                     print("moving down")
                    // }
                } else {
                    // UIView.animate(withDuration: 0.3) {
                    
                    if UIScreen.main.bounds.size.width == 320
                    {
                        self.uiView.center = CGPoint(x: self.trayOriginalCenter.x, y: 269.0)
                    }else if UIScreen.main.bounds.size.width == 375
                    {
                        self.uiView.center = CGPoint(x: self.trayOriginalCenter.x, y: 319.5)
                    }else if UIScreen.main.bounds.size.width == 414
                    {
                        self.uiView.center = CGPoint(x: self.trayOriginalCenter.x, y: 352.33332824707)
                        
                    }
                    
                    
                    // self.uiView.center = CGPoint(x: self.trayOriginalCenter.x, y: 145.833343505859)
                    //self.uiView.center = self.trayUp
                    
                    // print(CGPoint(x: self.trayOriginalCenter.x, y: self.trayOriginalCenter.y))
                    
                     print("moving up")
                    
                    //}
                }
                }, completion: nil)
            
            
            
            //print("Gesture ended")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    override func viewDidLoad() {
       // self.Scroller_ScrollerView.contentSize = self.view.frame.size
        self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)

       // self.Scroller_ScrollerView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width+1000)
        
        //self.automaticallyAdjustsScrollViewInsets = false
        /*
        self.automaticallyAdjustsScrollViewInsets = false
        if UIScreen.main.bounds.size.width == 320
        {
            // self.uiView.frame = CGPoint(x: uiView.center.x, y:  uiView.center.y)
            trayDownOffset = 20
            
            // self.uiView.frame.size = CGSize(width: 320, height: 500)
            self.uiView.frame.origin = CGPoint(x: uiView.center.x, y:  uiView.center.y)
        }else if UIScreen.main.bounds.size.width == 375
        {
            trayDownOffset = 20
            
            // self.uiView.frame.size = CGSize(width: 320, height: 500)
            self.uiView.frame.origin = CGPoint(x: uiView.center.x, y:  uiView.center.y)
            
            
        }
        
//        trayUp = uiView.center
//        trayDown = CGPoint(x: uiView.center.x ,y: uiView.center.y + trayDownOffset)
        
        
        super.viewDidLoad()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        uiView.isUserInteractionEnabled = true
        uiView.addGestureRecognizer(panGestureRecognizer)
        
        if UIScreen.main.bounds.size.width == 320
        {
            // self.uiView.frame = CGPoint(x: uiView.center.x, y:  uiView.center.y)
            
            trayDownOffset = 40
            // self.uiView.frame.size = CGSize(width: 320, height: 500)
            self.uiView.frame.origin = CGPoint(x: uiView.center.x, y:  uiView.center.y)
        }*/
        
        // tableView.contentInset = UIEdgeInsetsMake(250, 0, 0, 0)
        
        //        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //        self.uiView.addGestureRecognizer(gestureRecognizer)
        
        
        
        
        
        
        
        //scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+100)
        
        //        scrollView.contentSize = CGSize(width: self.uiView.frame.width, height: self.uiView.frame.height+100)
        //        tabBarControllerRef = self.tabBarController as! CustomTabBarClass
        //        tabBarControllerRef!.navigationControllerRef = self.navigationController as! CustomNavigationBarClass
        //        tabBarControllerRef!.viewControllerRef = self
        
        
        
        
        //        let tap = UITapGestureRecognizer(target: self, action: Selector(("handleTap:")))
        
//        if UIScreen.main.bounds.size.width == 320
//        {
//            self.uiView.frame.size = CGSize(width: 320, height: 400)
//            //self.uiView.frame.origin = CGPoint(x: uiView.center.x, y:  uiView.center.y)
//            
//        }
//        
        self.handleTap()
        
        self.tabViews()
        
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        }
        
        // Do any additional setup after loading the view.
   
    
    func handleTap()
    {
        //     uiView.removeFromSuperview()
    }
    
    func tabViews(){
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1:LFPhotosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFPhotosViewController") as! LFPhotosViewController
        controller1.title = "PHOTOS"
        controllerArray.append(controller1)
        
        let controller2 : LFFavouriteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFFavouriteViewController") as! LFFavouriteViewController
        controller2.title = "FAVORITES"
        controllerArray.append(controller2)
        
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorColor(UIColor.appTheamColor()),
            .selectedMenuItemLabelColor(UIColor.appTheamColor()),
            .menuHeight(40),
            .scrollMenuBackgroundColor(UIColor.white),
            .menuItemWidth(self.view.frame.size.width/2-16)
        ]
        
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.uiView.frame.width, height: self.uiView.frame.height), pageMenuOptions: parameters)
        
        self.uiView.addSubview((self.pageMenu?.view)!)
        
        //self.view.addSubview(View_DetailsView)
        
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        //self.Scroller_ScrollerView.contentOffset.x = 300
        return true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //self.Scroller_ScrollerView.contentOffset = CGPoint(x: 0.0, y: 300)

  //  print(">>>>scrollViewDidScroll")
    
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //self.Scroller_ScrollerView.contentOffset = CGPoint(x: 0.0, y: 300)
        //print(">>>>scrollViewWillBeginDragging")
    }
   func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
   
    if UIScreen.main.bounds.size.width == 320
    {
        
          self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        
    }else if UIScreen.main.bounds.size.width == 375
    {
         self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
        
    }else if UIScreen.main.bounds.size.width == 414
    {
        
  self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 870)
        
    }
    
   // self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 845)

         print(">>>> scrollViewWillEndDragging ")
//
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.Scroller_ScrollerView.contentOffset.y = 200
        print(self.Scroller_ScrollerView.contentInset)

        
    }

}

