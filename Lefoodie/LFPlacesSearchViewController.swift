//
//  LFPlacesSearchViewController.swift
//  Lefoodie
//
//  Created by Rambabu Mannam on 23/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFPlacesSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUpNavigationBar()
    }
    
    func setUpNavigationBar()
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        let menuItem = UIBarButtonItem(image: UIImage(named: "Back-48"), style: .plain, target: self, action: #selector(LFRestaurentDetailsViewController.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func backBtnClicked()
    {
        self.navigationController?.popViewController(animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
