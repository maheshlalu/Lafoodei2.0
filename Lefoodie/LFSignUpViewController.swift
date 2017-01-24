//
//  LFSignUpViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 05/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFSignUpViewController: UIViewController {
    @IBOutlet weak var tersOfServiceLbl: UILabel!

   
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBAction func CreateAccountBtnAction(_ sender: UIButton) {
      //  let viewcontroller:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFHomeViewController") as UIViewController
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.navigateToTabBar()
        
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
        
        
//        NotificationCenter.defaultCenter.addObserver(self,
//                                                         selector: #selector(LFSignUpViewController.keyboardWillShow(_:)),
//                                                         name: UIKeyboardWillShowNotification,
//                                                         object: nil)
//        NotificationCenter.defaultCenter.addObserver(self,
//                                                         selector: #selector(LFSignUpViewController.keyboardWillHide(_:)),
//                                                         name: UIKeyboardWillHideNotification,
//                                                         object: nil)
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
//        self.stackView.addGestureRecognizer(tap)
        
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
    
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y = -(keyboardSize.height-60)
            }
            else {
                
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if ((sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
            else {
                
            }
        }
    }
    
    
   

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        //        textField.resignFirstResponder()
        //        return true
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        self.stackView.resignFirstResponder()
//    }

   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}


    


