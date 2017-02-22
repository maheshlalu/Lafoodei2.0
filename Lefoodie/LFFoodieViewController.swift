//
//  LFFoodieViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 04/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit

class LFFoodieViewController: UIViewController {
    var foodiesArr = [SearchFoodies]()
    var isPageRefreshing = Bool()
    var page = String()
    var lastIndexPath = IndexPath()
    var isInitialLoad = Bool()
    
    @IBOutlet weak var foodieViewTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
       // self.foodieViewTableView.register(UINib(nibName: "LFFoodiesTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodieCell")
        page = "1"
        isInitialLoad = true
       serviceAPICall(keyword: "", pageNumber: page, pageSize: "5")
        
        NotificationCenter.default.addObserver(self, selector: #selector(LFFoodieViewController.foodieSearchNotification(_:)), name:NSNotification.Name(rawValue: "FoodieSearchNotification"), object: nil)

    }
    
     func foodieSearchNotification(_ notification: Notification) {
        let searchText = notification.object as! String
        page = "1"
        self.serviceAPICall(keyword: searchText, pageNumber: page, pageSize: "5")
        self.foodieViewTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    //MARK: calling foodie data from service
    func serviceAPICall(keyword: String,pageNumber:String,pageSize:String){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        LFDataManager.sharedInstance.getSearchFoodie(keyword: keyword,pageNumber:pageNumber,pageSize:pageSize) { (resultFoodies) in
            
            self.isPageRefreshing = false
            
            let lastIndexOfArr = self.foodiesArr.count - 1
            if !resultFoodies.isEmpty {
                self.foodiesArr.append(contentsOf: resultFoodies)
                
                // if it is Initial Load
                if self.isInitialLoad {
                    self.foodieViewTableView.reloadData()
                } else {
                    // if using page nation
                    let indexArr = NSMutableArray()
                    
                    for i in 1...resultFoodies.count {
                        let index = IndexPath.init(row: lastIndexOfArr + i, section: 0)
                        indexArr.add(index)
                    }
                    self.foodieViewTableView.beginUpdates()
                    self.foodieViewTableView.insertRows(at: (indexArr as NSArray) as! [IndexPath], with: .none)
                    self.foodieViewTableView.endUpdates()
                }
                
            }
        }
    }
    
}

//MARK: UITableView Delagate Methods
extension LFFoodieViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodiesArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodies = self.foodiesArr[indexPath.row]
        // Instantiate a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodieCell", for: indexPath) as! LFFoodiesTableViewCell
        cell.foodieImageView.layer.cornerRadius = 30
        cell.foodieImageView.clipsToBounds = true
        let imgUrl = URL(string: foodies.foodieImage) as URL!
        
        if imgUrl != nil{
            cell.foodieImageView.setImageWith(imgUrl, usingActivityIndicatorStyle: .gray)
            
        }else{
            cell.foodieImageView.image = UIImage(named: "placeHolder")
        }
        
        cell.foodieName.text = foodies.foodieName
        let following = foodies.foodieFollowingCount
        let follower = foodies.foodieFollowerCount
        cell.foodieFollowLbl.text = "\(follower) Followers . \(following) Following"
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //LFRestaurentDetailsViewController
        let dict = self.foodiesArr[indexPath.row]
        let restaurentView = self.storyboard!.instantiateViewController(withIdentifier: "LFRestaurentDetailsViewController") as! LFRestaurentDetailsViewController
        restaurentView.selectedFoodie = dict
        let navController = UINavigationController(rootViewController: restaurentView)
        navController.navigationItem.hidesBackButton = false
        self.present(navController, animated:true, completion: nil)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == foodieViewTableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                print("scroll did reached down")
                if isPageRefreshing == false {
                    isPageRefreshing=true
                    var num = Int(page)
                    num = num! + 1
                    page = "\(num!)"
                    isInitialLoad = false
                    self.serviceAPICall(keyword: "", pageNumber: page, pageSize: "5")
                    
                }
                
            }
        }
    }

}
