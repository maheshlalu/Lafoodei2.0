//
//  LFFoodietoBusinessViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 02/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFFoodietoBusinessViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var businessView: UIView!
    var pageMenu : CAPSPageMenu?
    override func viewDidLoad() {
        super.viewDidLoad()
        tabViews()
        scrollView.delegate = self
//        scrollView.contentOffset = CGPoint(x: 1000, y: 2300)
//        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 4000)
        self.scrollView.setContentOffset(
            CGPoint(x: 0,y: -self.scrollView.contentInset.top),
            animated: true)
        //scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        scrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth
//        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
//        // Do any additional setup after loading the view
//        scrollView.contentSize = CGSize(width: 400, height: 2300)
        
        //self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+80)

        // Do any additional setup after loading the view.
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let foregroundHeight = scrollView.contentSize.height - scrollView.bounds.height
//        let percentageScroll = scrollView.contentOffset.y / foregroundHeight
//        //let backgroundHeight = background.contentSize.height - CGRectGetHeight(background.bounds)
//        
//        scrollView.contentOffset = CGPoint(x: 0, y: foregroundHeight * percentageScroll)
//    }
//
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
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.businessView.frame.width, height: self.businessView.frame.height), pageMenuOptions: parameters)
        
        self.businessView.addSubview((self.pageMenu?.view)!)
    }
}
