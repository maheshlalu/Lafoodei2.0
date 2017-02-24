//
//  LFPostViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 22/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFPostViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttoncreated()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Flag / Report"
    }
    
    func buttoncreated(){
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 8, width: 60, height: 60)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = button
        self.navigationItem.setRightBarButton(item1, animated: true)
    }
    
    func cancelBtnAction()
    {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func reportBtnAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFThanksViewController")as? LFThanksViewController
        self.navigationController?.pushViewController(storyboard!, animated: true)
        self.title = ""
        
    }
    
    
}
