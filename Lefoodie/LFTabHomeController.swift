//
//  LFTabHomeController.swift
//  Lefoodie
//
//  Created by apple on 02/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFTabHomeController: UITabBarController {
    
    
    var previousIndex : Int!
    var navController:UINavigationController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.delegate = self
        self.previousIndex = 0
        self.setUpTabControllers()
        self.tabBar.barTintColor = UIColor.init(red: 253/250, green: 205/250, blue: 0/250, alpha: 5)
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addCameraButton()
    }
    
    func addCameraButton(){
        
        let imageCameraButton: UIImage! = UIImage(named: "CameraIcon")
        
        // Creates a Button
        let cameraButton = UIButton()
        
        // Sets width and height to the Button
        cameraButton.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.height+20, height: tabBar.frame.size.height)
        
        // Sets image to the Button
        cameraButton.setBackgroundImage(imageCameraButton, for: .normal)
        //        cameraButton.contentMode = .scaleAspectFit
        // Sets the center of the Button to the center of the TabBar
        cameraButton.center = self.tabBar.center
        cameraButton.backgroundColor = UIColor.white
        cameraButton.addTarget(self, action: #selector(cameraAction), for: .touchUpInside)
        cameraButton.contentMode = .scaleAspectFill
        // Adds the Button to the view
        self.view.addSubview(cameraButton)
    }
    
    
    func cameraAction()
    {
        
        //        let cameraCntrl = CXCameraSourceViewController()
        //        cameraCntrl.delegate = self
        //        cameraCntrl.cropHeightRatio = 0.6
        //        self.navController = UINavigationController(rootViewController: cameraCntrl)
        //        self.present(navController, animated: true, completion: nil)
        //        navController.isNavigationBarHidden = true
        // let viewcontroller = UIViewController()
        
        //if viewcontroller.isKind(of: LFTabCameraViewController.self){
        let cameraCntrl = CXCameraSourceViewController()
        cameraCntrl.delegate = self
        cameraCntrl.cropHeightRatio = 0.6
        self.navController = UINavigationController(rootViewController: cameraCntrl)
        self.present(navController, animated: true, completion: nil)
        navController.isNavigationBarHidden = true
        tabBarController?.selectedIndex = self.previousIndex
        //        }else{
        //            self.previousIndex = tabBarController?.selectedIndex
        //
        //        }
        //        
        
        
    }
    
    func setUpTabControllers(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        /*Home Controller*/
        let homeContoller : LFHomeViewController = (storyBoard.instantiateViewController(withIdentifier: "LFHomeViewController") as? LFHomeViewController)!
        // homeContoller.title = "Home"
        //firstTab.title = "UPDATES"
        let homeNav = UINavigationController(rootViewController: homeContoller)
        homeContoller.tabBarItem.image = UIImage(named: "HomeIcon")
        homeContoller.tabBarItem.title = nil
        homeContoller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        /*Search Controller */
        let searchContoller : LFSearchViewController = (storyBoard.instantiateViewController(withIdentifier: "LFSearchViewController") as? LFSearchViewController)!
        //searchContoller.title = "Search"
        searchContoller.tabBarItem.image = UIImage(named: "SearchIcon")
        searchContoller.tabBarItem.title = nil
        searchContoller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        
        /*Camera controller */
        let cameraControl : LFTabCameraViewController = (storyBoard.instantiateViewController(withIdentifier: "LFTabCameraViewController") as? LFTabCameraViewController)!
        //cameraControl.title = "Camera"
        //cameraControl.tabBarItem.image = UIImage(named: "CameraIcon")
        cameraControl.tabBarController?.tabBar.tintColor = UIColor.clear
        //cameraControl.tabBarItem.
        
        /*Notification Controller */
        let notificatonContoller : LFNotificationController = (storyBoard.instantiateViewController(withIdentifier: "LFNotificationController") as? LFNotificationController)!
        //notificatonContoller.title = "notificatoin"
        let notificationNav = UINavigationController(rootViewController: notificatonContoller)
        notificatonContoller.tabBarItem.image = UIImage(named: "NotificationIcon")
        notificatonContoller.tabBarItem.title = nil
        notificatonContoller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        /*Profile Controller */
        let profileContoller : LFUserProfileViewController = (storyBoard.instantiateViewController(withIdentifier: "LFUserProfileViewController") as? LFUserProfileViewController)!
        //profileContoller.title = "Profile"
        let profileNav = UINavigationController(rootViewController: profileContoller)
        profileContoller.tabBarItem.image = UIImage(named: "UserProfileIcon")
        profileContoller.tabBarItem.title = nil
        profileContoller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        //self.setViewControllers([homeNav,searchContoller,cameraControl,notificationNav,profileNav], animated: true)
        
        self.viewControllers = [homeNav,searchContoller,cameraControl,notificationNav,profileNav]
        
    }

}

extension LFTabHomeController:UITabBarControllerDelegate{
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        // print("clicked\(tabBarController.selectedIndex)")
        if viewController.isKind(of: LFTabCameraViewController.self){
            let cameraCntrl = CXCameraSourceViewController()
            cameraCntrl.delegate = self
            cameraCntrl.cropHeightRatio = 0.6
            self.navController = UINavigationController(rootViewController: cameraCntrl)
            self.present(navController, animated: true, completion: nil)
            navController.isNavigationBarHidden = true
            tabBarController.selectedIndex = self.previousIndex
        }else{
            self.previousIndex = tabBarController.selectedIndex
            
        }
        
        let tabBar = tabBarController.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 3.0)
       // print("clicked\(viewController)")
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        return true
    }
}


extension  LFTabHomeController:CXCameraSourceDelegate{
    
    func CXImageSelected(_ image: UIImage, source: CXMode){
        let storyBoard = UIStoryboard(name: "PhotoShare", bundle: Bundle.main)
        let profileContoller : LFShareFoodiePicViewController = (storyBoard.instantiateViewController(withIdentifier: "LFShareFoodiePicViewController") as? LFShareFoodiePicViewController)!
        switch source {
        case .camera:
            //print("Image captured from Camera")
            profileContoller.postImage = image
            self.navController?.pushViewController(profileContoller, animated: true)
            
        case .library:
            //print("Image selected from Camera Roll")
            profileContoller.postImage = image
            self.navController?.pushViewController(profileContoller, animated: true)
            
        default:
           // print("Image selected")
            profileContoller.postImage = image
            self.navController?.pushViewController(profileContoller, animated: true)
            
        }
    }
    
    func CXDismissedWithImage(_ image: UIImage, source: CXMode){
        switch source {
        case .camera: break
            //print("Called just after dismissed using Camera")
        case .library: break
           // print("Called just after dismissed using Camera Roll")
        default: break
           // print("Called just after dismissed")
        }
    }
    
    func CXClosed(){
        
       // print("Called when the close button is pressed")
        
    }
    
    func CXCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension UIImage {
    
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: size.height - lineWidth, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
