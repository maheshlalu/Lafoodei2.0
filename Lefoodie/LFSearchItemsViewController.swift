//
//  LFSearchItemsViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFSearchItemsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var searchItemsTableView: UITableView!
    
    var nameArray = ["Restaurants","Bars","Coffee & Tea","Order Pickup or Delivery","Reservations"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return nameArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
      let name = "mycell"
        var cell = tableView.dequeueReusableCell(withIdentifier: name)
        if cell == nil
        {
            
            cell = UITableViewCell.init(style: .default, reuseIdentifier: name)
        }
        
       tableView.allowsSelection = false
        
        cell?.textLabel?.text = nameArray[indexPath.row]
        cell?.textLabel?.font = UIFont(name: "Arial", size: 12.0)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }

}
