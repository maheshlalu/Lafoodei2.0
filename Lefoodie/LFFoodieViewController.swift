//
//  LFFoodieViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 04/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit
import RealmSwift

class LFFoodieViewController: UIViewController {
    var foodiesArr = [SearchFoodies]()
    var isPageRefreshing = Bool()
    var page = String()
    var lastIndexPath = IndexPath()
    var isInitialLoad = Bool()
    var refreshControl : UIRefreshControl!
    var myProfile : LFMyProfile!
    
    @IBOutlet weak var foodieViewTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.addThePullTorefresh()
       // self.foodieViewTableView.register(UINib(nibName: "LFFoodiesTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodieCell")
        page = "1"
        isInitialLoad = true
        self.foodiesArr = [SearchFoodies]()
       serviceAPICall(keyword: "", pageNumber: page, pageSize: "10")
        NotificationCenter.default.addObserver(self, selector: #selector(LFFoodieViewController.foodieSearchNotification(_:)), name:NSNotification.Name(rawValue: "FoodieSearchNotification"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.foodieViewTableView.reloadData()
    }
    
    func deleteTheFeedsInDatabase(){
        
        if page == "1" {
            let relamInstance = try! Realm()
            let feedData = relamInstance.objects(LFFoodies.self)
            try! relamInstance.write({
                relamInstance.delete(feedData)
            })
        }
    }
    
     func foodieSearchNotification(_ notification: Notification) {
        let searchText = notification.object as! String
        page = "1"
        self.isInitialLoad = true
        self.foodiesArr = [SearchFoodies]()
        self.serviceAPICall(keyword: searchText, pageNumber: page, pageSize: "10")
        self.foodieViewTableView.reloadData()
    }
    
    //MARK: Add The PullToRefresh
    
    func addThePullTorefresh(){
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.foodieViewTableView.addSubview(self.refreshControl)
        //self.homeTableView.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
    }
    
    func refresh(sender:UIRefreshControl) {
        
        self.foodiesArr = [SearchFoodies]()
        self.isInitialLoad = true
        self.page = "1"
        
        self.serviceAPICall(keyword:"",pageNumber: self.page, pageSize: "10")

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    //MARK: calling foodie data from service
    func serviceAPICall(keyword: String,pageNumber:String,pageSize:String){
        self.deleteTheFeedsInDatabase()
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        LFDataManager.sharedInstance.getSearchFoodie(keyword: keyword,pageNumber:pageNumber,pageSize:pageSize) { (resultFoodies) in

            self.isPageRefreshing = false
            
            let lastIndexOfArr = self.foodiesArr.count - 1
            if !resultFoodies.isEmpty {
                self.foodiesArr.append(contentsOf: resultFoodies)
                LFDataSaveManager.sharedInstance.saveFoodieDetailsInDB(foodiesData: resultFoodies)
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
             self.refreshControl.endRefreshing()
        }
    }
}

//MARK: UITableView Delagate Methods
extension LFFoodieViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodiesArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if foodiesArr.count == 0 {
            let cell = UITableViewCell()
            return cell
        }
        
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
        
        let realm = try! Realm()
        let predicate = NSPredicate.init(format: "foodieId=%@", foodies.foodieId)
        let userData = realm.objects(LFFoodies.self).filter(predicate).first
        cell.foodieName.text = foodies.foodieName
        let following = (userData?.foodieFollowingCount)!
        let follower = (userData?.foodieFollowerCount)!
        cell.foodieFollowLbl.text = "\(follower) Followers . \(following) Following"
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //LFRestaurentDetailsViewController
        let dict = self.foodiesArr[indexPath.row]
        let realm = try! Realm()
        self.myProfile = realm.objects(LFMyProfile.self).first
        
        if dict.foodieEmail == myProfile.userEmail{
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let profileContoller : LFUserProfileViewController = (storyBoard.instantiateViewController(withIdentifier: "LFUserProfileViewController") as? LFUserProfileViewController)!
            profileContoller.profileDetails = ProfileDetailsType.userType
            LFDataManager.sharedInstance.dataManager().selectedIndex = 4
            
        }else{
            let restaurentView = self.storyboard!.instantiateViewController(withIdentifier: "LFRestaurentDetailsViewController") as! LFRestaurentDetailsViewController
            restaurentView.selectedFoodie = dict
            let navController = UINavigationController(rootViewController: restaurentView)
            navController.navigationItem.hidesBackButton = false
            self.present(navController, animated:true, completion: nil)
        }
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
                    self.serviceAPICall(keyword: "", pageNumber: page, pageSize: "10")
                    
                }
                
            }
        }
    }

}
