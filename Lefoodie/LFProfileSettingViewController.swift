//
//  LFProfileSettingViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 30/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import MagicalRecord

class LFProfileSettingViewController: UIViewController {
    
    @IBAction func logoutBtnAction(_ sender: UIButton) {
        // Remove all userdefault values
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
        
        //Truncate database
        MagicalRecord.save({ (localContext) in
            UserProfile.mr_truncateAll(in: localContext)
            let appDelVar:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            appDelVar.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        })
    }
    
    @IBAction func settingBtnAction(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFUserDetailEditViewController")as? LFUserDetailEditViewController
        //        self.navigationController?.pushViewController(storyboard!, animated: true)
    }
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
}
