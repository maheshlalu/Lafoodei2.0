//
//  LFUserFollowerAndFollowingViewController.swift
//  Lefoodie
//
//  Created by Manishi on 2/28/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import RealmSwift

class LFUserFollowerAndFollowingViewController: UIViewController {
    
    @IBOutlet weak var navLbl: UILabel!
    @IBOutlet weak var FFTableView: UITableView!
    var foodiesArr : Results<LFFollowers>!
    var selectedFoodie : LFMyProfile!
    var isPageRefreshing = Bool()
    var page = String()
    var lastIndexPath = IndexPath()
    var isInitialLoad = Bool()
    var refreshControl : UIRefreshControl!
    var isFollower:Bool = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFollower{
            self.navLbl.text = "Followers"
            let realm = try! Realm()
            let predicate = NSPredicate.init(format:"isFollower==%@", NSNumber(value: true))
            foodiesArr = realm.objects(LFFollowers.self).filter(predicate)
        }else{
            self.navLbl.text = "Following"
            let realm = try! Realm()
            let predicate = NSPredicate.init(format:"isFollowing==%@", NSNumber(value: true))
            foodiesArr = realm.objects(LFFollowers.self).filter(predicate)
        }
        
        self.FFTableView.tableFooterView = UIView()
        //self.addThePullTorefresh()
        page = "1"
        //isInitialLoad = true

       // NotificationCenter.default.addObserver(self, selector: #selector(LFFoodieViewController.foodieSearchNotification(_:)), name:NSNotification.Name(rawValue: "FoodieSearchNotification"), object: nil)
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
//    func foodieSearchNotification(_ notification: Notification) {
//        let searchText = notification.object as! String
//        page = "1"
//        self.isInitialLoad = true
//        //self.foodiesArr : Results<LFFollowers>! =
//       // self.serviceAPICall(keyword: searchText, pageNumber: page, pageSize: "10")
//        self.FFTableView.reloadData()
//    }
    
    //MARK: Add The PullToRefresh
    
    func addThePullTorefresh(){
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.FFTableView.addSubview(self.refreshControl)
        //self.homeTableView.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
    }
    
    func refresh(sender:UIRefreshControl) {
        
        self.isInitialLoad = true
        self.page = "1"
        
        //self.serviceAPICall(keyword:"",pageNumber: self.page, pageSize: "10")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
   /* //MARK: calling foodie data from service
    func serviceAPICall(keyword: String,pageNumber:String,pageSize:String){
        self.deleteTheFeedsInDatabase()
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        LFDataManager.sharedInstance.getSearchFoodie(keyword: keyword,pageNumber:pageNumber,pageSize:pageSize) { (resultFoodies) in
            
            self.isPageRefreshing = false
            
            let lastIndexOfArr = self.foodiesArr.count - 1
            if !resultFoodies.isEmpty {
                self.foodiesArr.append(resultFoodies)
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
                    self.FFTableView.beginUpdates()
                    self.FFTableView.insertRows(at: (indexArr as NSArray) as! [IndexPath], with: .none)
                    self.FFTableView.endUpdates()
                }
                
            }
            self.refreshControl.endRefreshing()
        }
    }
 */
}


//MARK: UITableView Delagate Methods
extension LFUserFollowerAndFollowingViewController:UITableViewDataSource,UITableViewDelegate {
    
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
        let imgUrl = URL(string: foodies.followerImage) as URL!
        
        if imgUrl != nil{
            cell.foodieImageView.setImageWith(imgUrl, usingActivityIndicatorStyle: .gray)
            
        }else{
            cell.foodieImageView.image = UIImage(named: "placeHolder")
        }
        
        cell.foodieName.text = foodies.followerName
        let following = foodies.noOfFollowings
        let follower = foodies.noOfFollowers
        
        cell.foodieFollowLbl.text = "\(follower) Followers . \(following) Following"
        // Returning the cell
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //LFRestaurentDetailsViewController
        let dict = self.foodiesArr[indexPath.row]
        let restaurentView = self.storyboard!.instantiateViewController(withIdentifier: "LFRestaurentDetailsViewController") as! LFRestaurentDetailsViewController
        restaurentView.selectedFoodie = dict
        let navController = UINavigationController(rootViewController: restaurentView)
        navController.navigationItem.hidesBackButton = false
        
        LFDataManager.sharedInstance.sendTheFollwAndUnFollowPushNotification(isFollow: true, foodieDetails:dict)
        
        self.present(navController, animated:true, completion: nil)
    }
    */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == FFTableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                print("scroll did reached down")
                if isPageRefreshing == false {
                    isPageRefreshing=true
                    var num = Int(page)
                    num = num! + 1
                    page = "\(num!)"
                    isInitialLoad = false
                    //self.serviceAPICall(keyword: "", pageNumber: page, pageSize: "10")
                    
                }
            }
        }
    }
}
