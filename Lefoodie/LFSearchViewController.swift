//
//  LFSearchViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 02/01/17.
//  Copyright © 2017 NOVO. All rights reserved.
//

import UIKit

class LFSearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var foodItemsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "LFFoodItemsListTableViewCell", bundle: nil)
        self.foodItemsTableView.register(nib, forCellReuseIdentifier: "LFFoodItemsListTableViewCell")

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
      return 4
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFFoodItemsListTableViewCell", for: indexPath)as? LFFoodItemsListTableViewCell
        return cell!
        
    }

}
