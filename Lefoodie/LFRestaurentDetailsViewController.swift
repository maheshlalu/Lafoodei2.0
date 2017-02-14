//
//  LFRestaurentDetailsViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFRestaurentDetailsViewController: UIViewController,UIGestureRecognizerDelegate,UIScrollViewDelegate{
    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var restaurantScrollView: UIScrollView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var foodieName: UILabel!
    @IBOutlet weak var foodieFollowLbl: UILabel!
    @IBOutlet weak var foodieImgView: UIImageView!
    var arr : SearchFoodies!
    var pageMenu : CAPSPageMenu?
    var tap: UITapGestureRecognizer?
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.restaurantScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        tabViews()
        foodieDetails()

    }
    
    func foodieDetails(){
        
        self.foodieName.text = arr.foodieName
        
        let imgUrl = URL(string: arr.foodieImage) as URL!
        if imgUrl != nil{
           foodieImgView.setImageWith(imgUrl, usingActivityIndicatorStyle: .gray)
            
        }else{
            foodieImgView.image = UIImage(named: "placeHolder")
        }
        
        let following = arr.foodieFollowingCount
        let follower = arr.foodieFollowerCount
        foodieFollowLbl.text = "\(follower) Followers . \(following) Following"
        
    }
    
    @IBAction func settingBtnAction(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundlvarnil).instantiateViewController(withIdentifier: "LFItemDetailViewController")as? LFItemDetailViewController
        //        self.navigationController?.pushViewController(storyboard!, animated: true)
        
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
        } else if sender.state == .ended{
            UIView.transition(with: self.restaurantView, duration: 0.3, options: UIViewAnimationOptions.curveLinear, animations: {
                
                if velocity.y > 0 {
                    
                    
                    // UIView.animate(withDuration: 0.3) {
                    if UIScreen.main.bounds.size.width == 320
                    {
                        self.restaurantView.center = CGPoint(x: self.trayOriginalCenter.x, y: 544.0)
                    }else if UIScreen.main.bounds.size.width == 375
                    {
                        self.restaurantView.center = CGPoint(x: self.trayOriginalCenter.x, y: 592.0)
                    }else if UIScreen.main.bounds.size.width == 414
                    {
                        self.restaurantView.center = CGPoint(x: self.trayOriginalCenter.x, y:  646.0)
                        
                    }
                    
                    
                    print(CGPoint(x: self.trayOriginalCenter.x, y: self.trayOriginalCenter.y))
                    
                    print("moving down")
                    // }
                } else {
                    // UIView.animate(withDuration: 0.3) {
                    
                    if UIScreen.main.bounds.size.width == 320
                    {
                        self.restaurantView.center = CGPoint(x: self.trayOriginalCenter.x, y: 269.0)
                    }else if UIScreen.main.bounds.size.width == 375
                    {
                        self.restaurantView.center = CGPoint(x: self.trayOriginalCenter.x, y: 319.5)
                    }else if UIScreen.main.bounds.size.width == 414
                    {
                        self.restaurantView.center = CGPoint(x: self.trayOriginalCenter.x, y: 352.33332824707)
                        
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

    func tabViews(){
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1:LFPhotosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFPhotosViewController") as! LFPhotosViewController
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
        
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.restaurantView.frame.width, height: self.restaurantView.frame.height), pageMenuOptions: parameters)
        
        self.restaurantView.addSubview((self.pageMenu?.view)!)
        
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
            
            self.restaurantScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 670)
            
        }else if UIScreen.main.bounds.size.width == 375
        {
            self.restaurantScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
            
        }else if UIScreen.main.bounds.size.width == 414
        {
            
            self.restaurantScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 870)
            
        }
        
        // self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 845)
        
        print(">>>> scrollViewWillEndDragging ")
        //
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.restaurantScrollView.contentOffset.y = 20
        print(self.restaurantScrollView.contentInset)
    }
}
