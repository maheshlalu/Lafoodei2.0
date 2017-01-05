
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
    
    @IBOutlet weak var userImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userImageView.layer.cornerRadius = 38
        self.userImageView.clipsToBounds = true
        tabViews()
        
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        
        // Do any additional setup after loading the view.
    }
    
    func tabViews(){
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        
        let controller1:LFPhotosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFPhotosViewController") as! LFPhotosViewController
        controller1.title = "PHOTOS"
        controllerArray.append(controller1)
        
        let controller2 : LFFavouriteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFFavouriteViewController") as! LFFavouriteViewController
        controller2.title = "FAVOURITES"
        controllerArray.append(controller2)
        
        
        
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorColor(UIColor.yellow),
            .selectedMenuItemLabelColor(UIColor.white),
            .menuHeight(40),
            .scrollMenuBackgroundColor(UIColor.gray),
            .menuItemWidth(self.view.frame.size.width/2-16)
        ]
        
        
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.uiView.frame.width, height: self.uiView.frame.height), pageMenuOptions: parameters)
        
        self.uiView.addSubview(self.pageMenu!.view)
        
    }
    
    
}
