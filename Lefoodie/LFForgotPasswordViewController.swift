//
//  LFForgotPasswordViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 09/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFForgotPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       emailTextField.delegate = self
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        NotificationCenter.default.addObserver(self, selector: #selector(LFSignUpViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LFSignUpViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendAction(_ sender: Any) {//"Please enter valid email address."
        self.view.endEditing(true)
        print("Send button")
        if self.isValidEmail(self.emailTextField.text!) {
            LFDataManager.sharedInstance.forgotPassword(self.emailTextField.text!, completion: { (responseDict) in
                print(responseDict)
                let message = responseDict.value(forKey: "result") as? String
                let status: Int = Int(responseDict.value(forKey: "status") as! String)!
                if status == 1{
                    self.showAlert(message!, status: 1)
                }
            })
        } else {
            self.showAlert("Please enter valid email address", status: 0)
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        //print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
    
    
    func showAlert(_ message:String, status:Int) {
        let alert = UIAlertController(title: "Alert!!!", message:message , preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: KeyboardWillShow And KeyboardWillHide Methods
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
