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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
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
       // self.selectedIndex = self.previousIndex
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
       // homeContoller.title = "Home"
        //firstTab.title = "UPDATES"
        let homeNav = UINavigationController(rootViewController: homeContoller)
        homeContoller.tabBarItem.image = UIImage(named: "HomeIcon")
        
        /*Search Controller */
        let searchContoller : LFSearchViewController = (storyBoard.instantiateViewController(withIdentifier: "LFSearchViewController") as? LFSearchViewController)!
         //searchContoller.title = "Search"
        searchContoller.tabBarItem.image = UIImage(named: "SearchIcon")


        /*Camera controller */
          let cameraControl : LFTabCameraViewController = (storyBoard.instantiateViewController(withIdentifier: "LFTabCameraViewController") as? LFTabCameraViewController)!
         //cameraControl.title = "Camera"
        cameraControl.tabBarItem.image = UIImage(named: "CameraIcon")

        /*Notification Controller */
        let notificatonContoller : LFNotificationController = (storyBoard.instantiateViewController(withIdentifier: "LFNotificationController") as? LFNotificationController)!
         //notificatonContoller.title = "notificatoin"
        let notificationNav = UINavigationController(rootViewController: notificatonContoller)

       notificatonContoller.tabBarItem.image = UIImage(named: "NotificationIcon")

        /*Profile Controller */
        let profileContoller : LFUserProfileViewController = (storyBoard.instantiateViewController(withIdentifier: "LFUserProfileViewController") as? LFUserProfileViewController)!
         //profileContoller.title = "Profile"
        let profileNav = UINavigationController(rootViewController: profileContoller)
        profileContoller.tabBarItem.image = UIImage(named: "UserProfileIcon")

        self.tabBarController?.setViewControllers([homeNav,searchContoller,cameraControl,notificationNav,profileNav], animated: true)

        
    }

    
    
}

extension LFTabHomeController:UITabBarControllerDelegate{
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        // print("clicked\(tabBarController.selectedIndex)")
        if viewController.isKind(of: LFTabCameraViewController.self){
            let cameraCntrl = CXCameraSourceViewController()
            cameraCntrl.delegate = self
            cameraCntrl.cropHeightRatio = 0.6
            self.present(cameraCntrl, animated: true, completion: nil)
            tabBarController.selectedIndex = self.previousIndex
        }else{
            self.previousIndex = tabBarController.selectedIndex
            
        }
        
        let tabBar = tabBarController.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 3.0)
        print("clicked\(viewController)")
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        return true
    }
}


extension  LFTabHomeController:CXCameraSourceDelegate{
    
    func CXImageSelected(_ image: UIImage, source: CXMode){
        
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        
        
        //imageView.image = image
        
    }
    
    func CXDismissedWithImage(_ image: UIImage, source: CXMode){
        switch source {
        case .camera:
            print("Called just after dismissed FusumaViewController using Camera")
        case .library:
            print("Called just after dismissed FusumaViewController using Camera Roll")
        default:
            print("Called just after dismissed FusumaViewController")
        }
        
    }
    
    func CXClosed(){
        
        print("Called when the close button is pressed")
    
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
