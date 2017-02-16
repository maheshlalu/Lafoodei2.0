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

    @IBAction func forgotPasswordBtnAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFForgotPasswordViewController")
        self.navigationController?.pushViewController(storyboard, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmailtextfield.delegate = self
        tfPasswordtextfield.delegate = self
        
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
            print("Get Data is \(responceDic)")
            let Status = responceDic.value(forKey: "status") as! String
            if (Status == "-1"){
                self.showAlert(message: "Invalid Username or Password")
                CXDataService.sharedInstance.hideLoader()
                
            }else {
                let statusSucce = responceDic.value(forKey: "status")
                CXAppConfig.sharedInstance.resultString(input: statusSucce as AnyObject)
                print("result \(CXAppConfig.sharedInstance.resultString(input: statusSucce as AnyObject))")
                if (CXAppConfig.sharedInstance.resultString(input: statusSucce as AnyObject) == "1"){
                    LFDataManager.sharedInstance.getTheUserDetails(userEmail: (responceDic.value(forKey:"emailId") as? String)!) {
                        
                    }
                    UserDefaults.standard.set(true, forKey: "isLoggedUser")
                    CXAppConfig.sharedInstance.saveUserDataInUserDefaults(responceDic: responceDic)
                    CXDataService.sharedInstance.hideLoader()
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.navigateToTabBar()
                    
                    
                }
            }
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
    
    //MARK : textfield delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
