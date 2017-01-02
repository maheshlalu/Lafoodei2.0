//
//  LFTabHomeController.swift
//  Lefoodie
//
//  Created by apple on 02/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFTabHomeController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
        self.setUpTabControllers()
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
    
    
    func setUpTabControllers(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        /*Home Controller*/
        let homeContoller : LFHomeViewController = (storyBoard.instantiateViewController(withIdentifier: "LFHomeViewController") as? LFHomeViewController)!
        homeContoller.title = "Home"
        //firstTab.title = "UPDATES"
       // firstTab.tabBarItem.image = UIImage(named: "updateTabImg")
        
        /*Search Controller */
        let searchContoller : LFSearchViewController = (storyBoard.instantiateViewController(withIdentifier: "LFSearchViewController") as? LFSearchViewController)!
         searchContoller.title = "Search"
        
        /*Camera controller */
          let cameraControl : LFSearchViewController = (storyBoard.instantiateViewController(withIdentifier: "LFSearchViewController") as? LFSearchViewController)!
         cameraControl.title = "Camera"
        
        /*Notification Controller */
        let notificatonContoller : LFNotificationController = (storyBoard.instantiateViewController(withIdentifier: "LFNotificationController") as? LFNotificationController)!
         notificatonContoller.title = "notificatoin"
        
        /*Profile Controller */
        let profileContoller : LFProfileController = (storyBoard.instantiateViewController(withIdentifier: "LFProfileController") as? LFProfileController)!
         profileContoller.title = "Profile"
        
        self.tabBarController?.setViewControllers([homeContoller,searchContoller,cameraControl,notificatonContoller,profileContoller], animated: true)
        
        
    }

    
    
}

extension LFTabHomeController:UITabBarControllerDelegate{
    
   public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        
        
    }
}
