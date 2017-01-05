//
//  LFSignUpViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 05/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFSignUpViewController: UIViewController {

    @IBAction func CreateAccountBtnAction(_ sender: UIButton) {
      //  let viewcontroller:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFHomeViewController") as UIViewController
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.navigateToTabBar()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        // Do any additional setup after loading the view.
    }
    
    func navigateToTabBar(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let homeVC = LFTabHomeController() as UITabBarController
        appDelegate.window?.rootViewController = homeVC
        appDelegate.window?.makeKeyAndVisible()
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

}
