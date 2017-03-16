//
//  LFUniqueUserCreation.swift
//  Lefoodie
//
//  Created by SRINIVASULU on 15/03/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFUniqueUserCreation: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    var userEmail:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func nameRegistrationBtnAction(_ sender: UIButton) {
        
        //http://35.160.251.153:8081/Users/createUniqueUserName?email=yernagulamahesh@gmail.com&uniqueUserName=mahi
    
        if self.userNameTextField.text?.characters.count != 0 {
            let userName = self.userNameTextField.text!
            if let userEmail = userEmail  {
                CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+"Users/createUniqueUserName?", parameters: ["email":userEmail as AnyObject,"uniqueUserName":userName.trimmingCharacters(in: .whitespaces) as AnyObject]) { (responeDic) in
            
                    if let status = responeDic.value(forKey: "status") as? String {
                        if status == "-1" {
                            //User name not available.
                            self.showAlert(message: "User name not available")
                            CXDataService.sharedInstance.hideLoader()

                        }else{
                            //Directly navigate to home screen
                            
                            LFDataManager.sharedInstance.getTheUserDetails(userEmail: userEmail, completion: { (isGenaratedKey) in
                                CXDataService.sharedInstance.hideLoader()
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.navigateToTabBar()
                            })
                           
                        }
                    }
                }
            }
        }else{
            self.showAlert(message: "Please Enter Name")
        }
        
        
        
        
       
        
    }
    
    //MARK: Show textfield alert
    func showAlert(message:String)
    {
        let alert = UIAlertController.init(title: "LeFoodie", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Unique Name Registration"
    }

   

}
