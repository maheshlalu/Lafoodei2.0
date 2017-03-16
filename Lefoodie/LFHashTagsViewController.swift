//
//  LFHashTagsViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 05/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit
import RealmSwift

class LFHashTagsViewController: UIViewController {

    var hashTagsArray = NSArray()
    var hashTagsList : Results<LFHashTags>!
    
    @IBOutlet weak var hashTagsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LFDataManager.sharedInstance.getHashTagDataFromServer()
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
        if hashTagsList == nil {
            return 0
        }
        else {
            return hashTagsList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Instantiate a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HashTagCell", for: indexPath) as! LFHashTagsTableViewCell
        
        let obj = hashTagsList[indexPath.row] as! LFHashTags
        
        cell.nameLabel.text = "#\(obj.name)"
        cell.countLabel.text = "\(obj.count) posts"
        
        // Returning the cell
        return cell
    }
    
    
}

