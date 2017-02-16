//
//  LFChangePasswordTableViewCell.swift
//  Lefoodie
//
//  Created by Rama kuppa on 15/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFChangePasswordTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var againNewPasswordTextFiled: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.endEditing(true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
