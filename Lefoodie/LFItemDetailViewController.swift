//
//  LFItemDetailViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFItemDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var itemTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()

        // Do any additional setup after loading the view.
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        //let Dict_Detail = self.Arr_Main.object(at: indexPath.section) as AnyObject
        if indexPath.row == 0 {
            
            cell  = (tableView.dequeueReusableCell(withIdentifier: "LFItemHeaderTableViewCell", for: indexPath)as? LFItemHeaderTableViewCell)!
            
        }else if indexPath.row == 1 {
            
            cell  = (tableView.dequeueReusableCell(withIdentifier: "LFItemCenterTableViewCell", for: indexPath)as? LFItemCenterTableViewCell)!
            
        }else if indexPath.row == 2 {
            cell  = (tableView.dequeueReusableCell(withIdentifier: "LFItemFooterTableViewCell", for: indexPath)as? LFItemFooterTableViewCell)!
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
            
        }else if indexPath.row == 1 {
            return 220
            
        }else if indexPath.row == 2 {
            return 45
            
        }
        return 0
    }
    
    func registerCells(){
        self.itemTableView.register(UINib(nibName: "LFItemHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LFItemHeaderTableViewCell")
        self.itemTableView.register(UINib(nibName: "LFItemCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFItemCenterTableViewCell")
        self.itemTableView.register(UINib(nibName: "LFItemFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFItemFooterTableViewCell")
    }
    


}
