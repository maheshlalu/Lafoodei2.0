//
//  LFOptionsViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 14/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import MagicalRecord

class LFOptionsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var optionsTableView: UITableView!
    let sections = ["INVITE","Follow People","Accounts"]
    let items = [["Facebook Friends"],["Facebook Friends","Contacts"],["Edit Profile","Change Password","Logout"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationProperty()
        let nib = UINib(nibName: "LFOptionalTableViewCell", bundle: nil)
        self.optionsTableView.register(nib, forCellReuseIdentifier: "LFOptionalTableViewCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func navigationProperty()
    {
        
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        //v.textLabel?.font = UIFont(name: "Arial", size: 8)
        v.textLabel?.textColor = UIColor.lightGray
        v.textLabel?.font = UIFont.boldSystemFont(ofSize: 8)
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
       return self.sections.count
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.items[section].count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
       let cell = tableView.dequeueReusableCell(withIdentifier: "LFOptionalTableViewCell", for: indexPath)as? LFOptionalTableViewCell
    
        cell?.nameLabel.text = self.items[indexPath.section][indexPath.row]
        cell?.nameLabel.font = UIFont(name: "Arial", size: 10)
       cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 35
        }
        else if indexPath.section == 1
        {
            return 35
        }
        else{
            return 35
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFUserDetailEditViewController")as? LFUserDetailEditViewController
            self.navigationController?.pushViewController(storyboard!, animated: true)
        }
        else if indexPath.section == 2 && indexPath.row == 2
        {
            
          self.showAlert("Are u sure", status: 0)
        }
    }
    
    func showAlert(_ message:String, status:Int) {
        let alert = UIAlertController(title: "Alert", message:message , preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            if let bundle = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundle)
            }
            let appDelVar:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            appDelVar.logOutFromTheApp()
            //Truncate database
            MagicalRecord.save({ (localContext) in
                UserProfile.mr_truncateAll(in: localContext)
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
   

    
}
