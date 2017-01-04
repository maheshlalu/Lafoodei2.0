//
//  ViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 03/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit

class LFSearchViewController: UIViewController {
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchTypeLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    var navController1 = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBtn.layer.cornerRadius = 3
        searchBtn.clipsToBounds = true
        searchTypeLabel.layer.cornerRadius = 3
        searchTypeLabel.clipsToBounds = true
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "LFFoodieViewController") as! LFFoodieViewController
        navController1 = UINavigationController(rootViewController: VC1)
        navController1.isNavigationBarHidden = true
        
        addChildViewController(self.navController1)
        self.navController1.view.frame = self.containerView.bounds
        self.containerView.addSubview(navController1.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




