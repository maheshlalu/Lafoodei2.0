//
//  LFChangePasswordTableViewCell.swift
//  Lefoodie
//
//  Created by Rama kuppa on 15/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFChangePasswordTableViewCell: UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var currentPasswordView: UIView!

    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var againNewPasswordView: UIView!
    @IBOutlet weak var againNewPasswordTextFiled: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newPasswordTextField.delegate = self
        currentPasswordTextField.delegate = self
        againNewPasswordTextFiled.delegate = self
        
        self.currentPasswordView.layer.cornerRadius = 2
        self.currentPasswordView.layer.borderWidth = 1
        self.currentPasswordView.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
        
        self.newPasswordView.layer.cornerRadius = 2
        self.newPasswordView.layer.borderWidth = 1
        self.newPasswordView.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true

        self.againNewPasswordView.layer.cornerRadius = 2
        self.againNewPasswordView.layer.borderWidth = 1
        self.againNewPasswordView.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true

        // Initialization code
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        //self.view.endEditing(true)
        self.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
