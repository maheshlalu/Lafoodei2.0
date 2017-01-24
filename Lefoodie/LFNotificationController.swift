//
//  LFNotificationController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 06/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFNotificationController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var nameArray = ["Alexandra added a photo to Best Cocktails Ever! list.","Alexandra added a photo to Best Cocktails Ever! list","Alexandra added a photo to Best Cocktails Ever! list","Alexandra added a photo to Best Cocktails Ever! list","Alexandra added a photo to Best Cocktails Ever! list","Alexandra added a photo to Best Cocktails Ever! list"]
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LFNotificationTableViewCell", bundle: nil)
        self.notificationTableView.register(nib, forCellReuseIdentifier: "LFNotificationTableViewCell")
        self.notificationTableView.estimatedRowHeight = 60
        self.notificationTableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFNotificationTableViewCell", for: indexPath)as? LFNotificationTableViewCell
        cell?.nameLabel.text = nameArray[indexPath.row]
        tableView.allowsSelection = false
        if indexPath.row == 5
        {
                cell?.imageStackView.isHidden = false
        }
        else
        {
                cell?.imageStackView.isHidden = true
        }
        
        tableView.separatorStyle = .singleLine
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 5
        {
                return 197
        }
        else
        {
            return 68
        }
    }
    
}
