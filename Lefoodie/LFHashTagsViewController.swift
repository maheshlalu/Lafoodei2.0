//
//  LFHashTagsViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 05/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit

class LFHashTagsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(LFHashTagsViewController.hashTagsSearchNotification(_:)), name:NSNotification.Name(rawValue: "HashTagsSearchNotification"), object: nil)
        
    }
    
    func hashTagsSearchNotification(_ notification: Notification) {
        let searchText = notification.object as! String
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: UITableView Delagate Methods
extension LFHashTagsViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Instantiate a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HashTagCell", for: indexPath) as! LFHashTagsTableViewCell
        
        // Returning the cell
        return cell
    }
    
    
}

