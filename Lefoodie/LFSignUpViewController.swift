//
//  LFSignUpViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 05/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import MagicalRecord

class LFSignUpViewController: UIViewController {
    @IBOutlet weak var tersOfServiceLbl: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    var alertTextField:UITextField! = nil
    let limitLength = 10
    //MARK:TextFields validation
    @IBAction func CreateAccountBtnAction(_ sender: UIButton) {
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.navigateToTabBar()
//        return
        
        if (self.userNameTextField.text?.characters.count) == 0
        {
            showAlert(message: "Please enter user name")
        }
        else if (self.emailTextField.text?.characters.count) == 0
        {
            showAlert(message: "Please enter Email Id")
        }
        else if (self.passwordTextField.text?.characters.count) == 0
        {
            showAlert(message: "Please enter Password")
        }
        else if !self.isValidEmail(email: self.emailTextField.text!)
        {
            showAlert(message: "Please enter valid mail")
        }
        else{
            self.sendSignUpDetails()
            print("All fields have data")

        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        
    }
    func sendSignUpDetails()
    {
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading..")
        let userRegisterDic: NSDictionary = NSDictionary(objects: [self.emailTextField.text!,self.passwordTextField.text!,self.userNameTextField.text!,"",""],
                                                         forKeys: ["userEmailId" as NSCopying,"password" as NSCopying,"firstName" as NSCopying,"lastName" as NSCopying,"gender" as NSCopying])
       
        MagicalRecord.save({ (localContext) in
            
            UserProfile.mr_truncateAll(in: localContext)
        })
        CX_SocialIntegration.sharedInstance.applicationRegisterWithSignUp(userDataDic: userRegisterDic, completion: { (isRegistred) in
            
            if isRegistred {
                
                print(isRegistred)
                self.showAlert(message: "You are Successfully Registered", status: 1)
                UserDefaults.standard.set(true, forKey: "isLoggedUser")
            }
            else {
                CXDataService.sharedInstance.hideLoader()
                self.showAlert(message: "This Email already exists", status: 0)
            }
            
            
        })
    }
    
    
    func showAlert(message:String,status:Int)
    {
        let alertController = UIAlertController(title: "LeFoodie", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            if status == 0 {
                
            }
            else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.navigateToTabBar()
            }
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    }

    
    
    //MARK: Show textfield alert
    func showAlert(message:String)
    {
        let alert = UIAlertController.init(title: "LeFoodie", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        let firstWord   = "By creating an account, you are agreeing to our \n"
        let secondWord = "Terms of service"
        let thirdWord   = "Privacy policy"
        // let finaString =  NSAttributedString(string: firstWord).
        
        let attributedText = NSMutableAttributedString(string:firstWord)
        attributedText.append(attributedString(from: secondWord, nonBoldRange: NSMakeRange(0, secondWord.characters.count-1)))
        attributedText.append(NSAttributedString(string: " and "))
        attributedText.append(attributedString(from: thirdWord, nonBoldRange: NSMakeRange(0, thirdWord.characters.count-1)))
        tersOfServiceLbl.attributedText =  attributedText
        NotificationCenter.default.addObserver(self, selector: #selector(LFSignUpViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LFSignUpViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.stackView.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        //let fontSize = UIFont.systemFontSize
        let attrs = [
            NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.white
        ]
        let nonBoldAttribute = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
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
    
    func isValidEmail(email: String) -> Bool {
        // print("validate email: \(email)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    //MARK: Keyboard Delegate
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
    //MARK: Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}





