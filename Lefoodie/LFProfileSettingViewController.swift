//
//  LFProfileSettingViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 30/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
//import MagicalRecord

class LFProfileSettingViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func showAlert(_ message:String, status:Int) {
        let alert = UIAlertController(title: "Alert", message:message , preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            if let bundle = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundle)
            }
            let appDelVar:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            appDelVar.logOutFromTheApp()
            //Truncate database
            MagicalRecord.save({ (localContext) in
                UserProfile.mr_truncateAll(in: localContext)
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

    }*/
    
    @IBAction func logoutBtnAction(_ sender: UIButton) {
        //self.showAlert("Are you sure?", status: 0)
        
        // Remove all userdefault values
       
    }
    
    @IBAction func settingBtnAction(_ sender: UIButton) {
        
                let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFOptionsViewController")as? LFOptionsViewController
                self.navigationController?.pushViewController(storyboard!, animated: true)
    }
}
