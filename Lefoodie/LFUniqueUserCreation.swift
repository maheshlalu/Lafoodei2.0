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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func nameRegistrationBtnAction(_ sender: UIButton) {
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Unique Name Registration"
    }

   

}
