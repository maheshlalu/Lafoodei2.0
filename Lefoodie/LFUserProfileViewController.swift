
//
//  LFUserProfileViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 03/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFUserProfileViewController: UIViewController {
    
 
    

    
    @IBOutlet weak var uiView: UIView!
    var pageMenu : CAPSPageMenu?
    var tap: UITapGestureRecognizer?
    
    
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        //scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+100)
        
//        scrollView.contentSize = CGSize(width: self.uiView.frame.width, height: self.uiView.frame.height+100)
//        tabBarControllerRef = self.tabBarController as! CustomTabBarClass
//        tabBarControllerRef!.navigationControllerRef = self.navigationController as! CustomNavigationBarClass
//        tabBarControllerRef!.viewControllerRef = self
        


     
//        let tap = UITapGestureRecognizer(target: self, action: Selector(("handleTap:")))
        
       
        handleTap()
        
        tabViews()
        
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        
        // Do any additional setup after loading the view.
    }
    
   func handleTap()
   {
//     uiView.removeFromSuperview()
    }
    
    func tabViews(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //uiView.isUserInteractionEnabled = true
        
        
       
        
   
        self.view.addSubview(uiView)
        
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
        self.uiView.addSubview(self.pageMenu!.view)
        
    }
    
    
   
    
  

    
    
}
