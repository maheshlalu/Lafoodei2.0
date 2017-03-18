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
    
    var isSearch = Bool()
    
    @IBOutlet weak var hashTagsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSearch = false
        LFDataManager.sharedInstance.getHashTagDataFromServer()
        getHashTagsFromDB()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(LFHashTagsViewController.hashTagsSearchNotification(_:)), name:NSNotification.Name(rawValue: "HashTagsSearchNotification"), object: nil)
        
    }
    
    func getHashTagsFromDB()
    {
        let realm = try! Realm()
        hashTagsList = realm.objects(LFHashTags.self)
    }
    
    func hashTagsSearchNotification(_ notification: Notification) {
        isSearch = true
        var searchText = notification.object as! String
        if searchText[searchText.startIndex] == "#" {
           searchText.remove(at: searchText.startIndex)
        }
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading..")
        let urlStr = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getHashTagsApiUsingKeyword()
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(urlStr, parameters: ["keyWord":searchText as AnyObject]) { (responseDic) in
            self.hashTagsArray = responseDic.value(forKey: "hashTags") as! NSArray
            self.hashTagsTableView.reloadData()
            CXDataService.sharedInstance.hideLoader()
        }
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
        // while user searching for HashTags
        if isSearch {
            return hashTagsArray.count
        }
        //while user doesn't searching for HashTags
        else {
            if hashTagsList == nil {
                return 0
            }
            else {
                return hashTagsList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Instantiate a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HashTagCell", for: indexPath) as! LFHashTagsTableViewCell
        
        // while user searching for HashTags
        if isSearch {
            let obj = hashTagsArray[indexPath.row] as! NSDictionary
            cell.nameLabel.text = "#\(obj.value(forKey: "Name")!)"
            cell.countLabel.text = "\(obj.value(forKey: "Count")!) posts"
        }
        //while user doesn't searching for HashTags
        else {
            let obj = hashTagsList[indexPath.row]
            cell.nameLabel.text = "#\(obj.name)"
            cell.countLabel.text = "\(obj.count) posts"
        }

        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let hashtagcontroller : LFHashTagDetailController = (storyBoard.instantiateViewController(withIdentifier: "LFHashTagDetailController") as? LFHashTagDetailController)!
        let navController = UINavigationController(rootViewController: hashtagcontroller)
        navController.navigationItem.hidesBackButton = false
        
        if isSearch {
            let obj = hashTagsArray[indexPath.row] as! NSDictionary
            let hastTag = obj.value(forKey: "Name") as! String?
            hashtagcontroller.hashTagNamestr = "#" + hastTag!
        }
        else {
            let obj = hashTagsList[indexPath.row]
            hashtagcontroller.hashTagNamestr = obj.name
        }
        
        //self.navigationController?.pushViewController(hashtagcontroller, animated: true)
        self.present(navController, animated: true, completion: nil)
    }
    
    
}

