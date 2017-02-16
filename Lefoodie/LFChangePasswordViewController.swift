//
//  LFChangePasswordViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 15/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFChangePasswordViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var passwordTableView: UITableView!
    let item1 = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let nib = UINib(nibName: "LFChangePasswordTableViewCell", bundle: nil)
        self.passwordTableView.register(nib, forCellReuseIdentifier: "LFChangePasswordTableViewCell")
        
        buttonCreated()
        setNavigationProperties()
    }
    
    
    func buttonCreated()
    {
        let button = UIButton()
        button.frame = CGRect(x: 8, y: 8, width: 50, height: 40)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        item1.customView = button
        item1.isEnabled = false
        self.navigationItem.setRightBarButton(item1, animated: true)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    func buttonAction()
    {
        let indexPath : NSIndexPath = NSIndexPath(row: 0, section: 0)
        
        let cell: LFChangePasswordTableViewCell = self.passwordTableView.cellForRow(at: indexPath as IndexPath) as! LFChangePasswordTableViewCell
        
        print(cell.currentPasswordTextField.text)
        print(cell.newPasswordTextField.text)
        print(cell.againNewPasswordTextFiled.text)
        
        if (cell.currentPasswordTextField.text?.characters.count)! > 0
            && (cell.newPasswordTextField.text?.characters.count)! > 0
            && (cell.againNewPasswordTextFiled.text?.characters.count)! > 0 {
            
            if cell.newPasswordTextField.text != cell.againNewPasswordTextFiled.text{
                let alert = UIAlertController(title: "Alert!", message:"Password doesn't match!", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (alert) in
                    cell.newPasswordTextField.text  = nil
                    cell.againNewPasswordTextFiled.text = nil
                }))
                
            }else{
                
                let userEmail = CXAppConfig.sharedInstance.getEmailID() as String
                
                LFDataManager.sharedInstance.changePassword(email: userEmail, currentPsw: cell.currentPasswordTextField.text!, newPsw: cell.newPasswordTextField.text!, confirmPsw: cell.againNewPasswordTextFiled.text!, completion: { (responseDict) in
                    print(responseDict)
                    let message = responseDict.value(forKeyPath: "myHashMap.msg") as! String
                    let status: Int = Int(responseDict.value(forKeyPath: "myHashMap.status") as! String)!
                    self.showAlertView(message: message, status: status)
                })
            }
        }
    }
    
    func setNavigationProperties(){
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFChangePasswordTableViewCell", for: indexPath)as? LFChangePasswordTableViewCell
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    func showAlertView(message:String, status:Int) {
        DispatchQueue.main.sync {
            let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
                UIAlertAction in
                if status == 1 {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        item1.isEnabled = true
    }
}

