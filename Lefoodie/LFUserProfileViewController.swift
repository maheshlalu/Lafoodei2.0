
//
//  LFUserProfileViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 03/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFUserProfileViewController: UIViewController,UIGestureRecognizerDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var userPic: UIImageView!
    
    @IBOutlet weak var userFirstNameLbl: UILabel!
    
    @IBOutlet weak var userLastNameLbl: UILabel!
    
    @IBOutlet weak var followersCountLbl: UILabel!
    
    @IBOutlet weak var followingCountLbl: UILabel!
    
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
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    override func viewDidLoad() {
        self.handleTap()
        self.tabViews()
        
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        
          NotificationCenter.default.addObserver(self, selector: #selector(LFUserProfileViewController.scrollUp), name:NSNotification.Name(rawValue: "scrollUp"), object: nil)
        
           NotificationCenter.default.addObserver(self, selector: #selector(LFUserProfileViewController.scrollDown), name:NSNotification.Name(rawValue: "ScrollDown"), object: nil)
        //self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 1680)

    }
    
    
    func scrollUp(){
        print(self.Scroller_ScrollerView.contentOffset)
        let offset : CGFloat = Scroller_ScrollerView.contentOffset.y
        //print(offset)
        if offset >= 0 {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.Scroller_ScrollerView.contentOffset = CGPoint(x: 0, y: 300)
            }, completion: { finished in
            })
        }
        
        
    }
    
    func scrollDown(){
        let offset : CGFloat = Scroller_ScrollerView.contentOffset.y
      //  print(offset)
        if offset >= 290 {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.Scroller_ScrollerView.contentOffset = CGPoint(x: 0, y: 0)
            }, completion: { finished in
            })
        }

    }
    
    @IBAction func settingBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFOptionsViewController")as! LFOptionsViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
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
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView){
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
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
        //print(">>>> scrollViewWillEndDragging ")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //self.Scroller_ScrollerView.contentOffset.y = 200
        //print(self.Scroller_ScrollerView.contentInset)
        
    }
    
    
   /*func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        let actualPosition: CGPoint = scrollView.contentOffset

        print(scrollView.contentOffset)
        let offset : CGFloat = scrollView.contentOffset.y
        print(offset)
        print(actualPosition)
        if (actualPosition.y > 0){
            // Dragging down
            if offset >= 0 {
               // self.Scroller_ScrollerView.contentOffset = 0;

                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                    scrollView.contentOffset = CGPoint(x: 0, y: 400)
                }, completion: { finished in
                })
            }
        }else{
            // Dragging up
            //scrollView.contentOffset = CGPoint(x: 0, y: 0)
            if offset >= 400 {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                    scrollView.contentOffset = CGPoint(x: 0, y: 0)
                }, completion: { finished in
                })
            }

            //self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        }
    }*/

    
  
    

}
