//
//  LFHotItemViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 22/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFHotItemViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var hotItemTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hotItemTableView.estimatedRowHeight = 471
        self.hotItemTableView.rowHeight = UITableViewAutomaticDimension
        let nib = UINib(nibName: "LFHotItemTableViewCell", bundle: nil)
        self.hotItemTableView.register(nib, forCellReuseIdentifier: "LFHotItemTableViewCell")
        

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFHotItemTableViewCell", for: indexPath)as? LFHotItemTableViewCell
        cell?.selectionStyle = .none
        return cell!
        
    }
    
    
    
}
