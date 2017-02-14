//
//  LFUserDetailEditViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import GoogleSignIn

class LFUserDetailEditViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    //var strKeyvalues = NSString()
    var alertTextField:UITextField! = nil
    //var nameArray = ["First Name","Last Name","Birth Date","E-Mail","Phone"]
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var editTableView: UITableView!
    var moveValue: CGFloat!
    var moved: Bool = false
    var activeTextField = UITextField()
    var nameArray = ["First Name","Last Name","Birth Date","E-Mail","Phone"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //strKeyvalues = "Edit"
        NotificationCenter.default.addObserver(self, selector: #selector(LFUserDetailEditViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LFUserDetailEditViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        
        let nib = UINib(nibName: "LFEditTableViewCell", bundle: nil)
        self.editTableView.register(nib, forCellReuseIdentifier: "LFEditTableViewCell")
        buttoncreated()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
    }
    //Button Created
    func buttoncreated()
    {
        
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 8, width: 40, height: 40)
        button.setTitle("Edit", for: .normal)
        button.setTitle("Save", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = button
        self.navigationItem.setRightBarButton(item1, animated: true)
    }
    
    //MARK: Button Action
    func buttonAction(_ sender:UIButton){
        
        if(sender.titleLabel?.text == "Edit")
        {
            //Edit Action
            sender.isSelected = !sender.isSelected
            sender.setImage(UIImage(named:"item1"), for: UIControlState.normal)
            
        }else if sender.titleLabel?.text == "Save" {
            sender.isSelected = !sender.isSelected
            //Save action
        }
        self.editTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFEditTableViewCell", for: indexPath)as? LFEditTableViewCell
        cell?.nameLabel.text = nameArray[indexPath.row]
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        cell?.stackView.addGestureRecognizer(tap)
        tableView.allowsSelection = false
        cell?.infoTextfield.delegate = self
        return cell!
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        // Additional code here
        return true
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    //MARK: Keyboard willshow and Will hide Methods
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = 0
            if view.frame.origin.y == 0{
                self.view.frame.origin.y = -(keyboardSize.height-130)
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
    //    override func viewWillDisappear(_ animated: Bool) {
    //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    //    }
    
    
}
