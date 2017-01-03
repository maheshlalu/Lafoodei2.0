//
//  LFTabCameraViewController.swift
//  Lefoodie
//
//  Created by Manishi on 1/2/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFTabCameraViewController: UIViewController, CXCameraSourceDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
    }

    @IBAction func btnAction(_ sender: Any) {
        
        let fusuma = CXCameraSourceViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 0.6
        self.present(fusuma, animated: true, completion: nil)
        
    }
    
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
