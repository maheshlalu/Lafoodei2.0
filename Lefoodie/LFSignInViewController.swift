//
//  LFSignInViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 07/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFSignInViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tfEmailtextfield: UITextField!
    
    @IBOutlet weak var tfPasswordtextfield: UITextField!
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)


        NotificationCenter.default.addObserver(self, selector: #selector(LFSignUpViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LFSignUpViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.stackView.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
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
    
    
    // MARK : Test conditions for signin 
    
    func loginValidation()
    {
        if (self.tfEmailtextfield.text?.characters.count) == 0
        {
            showAlert(message: "Please enter Email id")
        }
        else if (self.tfPasswordtextfield.text?.characters.count) == 0
        {
            showAlert(message: "Please enter password")
        }else{
            self.signin()
            print("All fields have data")
            
        }

    
    
    }
    
    // MARK : signin Details
    func signin(){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading..")
         let signInUrl = CXAppConfig.sharedInstance.getBaseUrl() + "MobileAPIs/loginConsumerForOrg?orgId="+CXAppConfig.sharedInstance.getAppMallID()+"&email="+self.tfEmailtextfield.text!+"&dt=DEVICES&password="+self.tfPasswordtextfield.text!
        let urlStr = NSString.init(string: signInUrl)
        print(urlStr)
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(urlStr as String, parameters: ["":"" as AnyObject]) { (responceDic
            ) in
           // print("Get Data is \(responceDic)")
           
            CXAppConfig.sharedInstance.saveUserDataInUserDefaults(responceDic: responceDic)
            CXDataService.sharedInstance.hideLoader()
        }

        

    }
    
    func showAlert(message:String)
    {
        let alert = UIAlertController.init(title: "LeFoodie", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK : Sign in button Action

    @IBAction func btnSignInTapped(_ sender: Any) {
        loginValidation()
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = 0
            if view.frame.origin.y == 0{
                self.view.frame.origin.y = -(keyboardSize.height-65)
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if ((sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y = 65
            }
            else {
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        
    }
}
