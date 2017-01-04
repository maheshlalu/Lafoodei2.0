//
//  LFHomeViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 30/12/16.
//  Copyright © 2016 NOVO. All rights reserved.
//

import UIKit

class LFHomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var homeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.selectedTabBar()
    }
    
    
    func registerCells(){
        self.homeTableView.register(UINib(nibName: "LFHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHeaderTableViewCell")
        self.homeTableView.register(UINib(nibName: "LFHomeCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHomeCenterTableViewCell")
        self.homeTableView.register(UINib(nibName: "LFHomeFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHomeFooterTableViewCell")
    }
    
    func selectedTabBar(){
        
        let tabBar = self.tabBarController?.tabBar
        tabBar?.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: (tabBar?.frame.width)!/CGFloat((tabBar?.items!.count)!), height: (tabBar?.frame.height)!), lineWidth: 3.0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       return 3
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHeaderTableViewCell", for: indexPath)as? LFHeaderTableViewCell)!
        }else if indexPath.row == 1 {
              cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHomeCenterTableViewCell", for: indexPath)as? LFHomeCenterTableViewCell)!
        }else if indexPath.row == 2 {
              cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHomeFooterTableViewCell", for: indexPath)as? LFHomeFooterTableViewCell)!
            
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 75

        }else if indexPath.row == 1 {
            return 200

        }else if indexPath.row == 2 {
            return 75

        }
        return 0
    }
    

   

}
