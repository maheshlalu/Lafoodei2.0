
//
//  LFHomeViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 30/12/16.
//  Copyright © 2016 NOVO. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import RealmSwift
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LFHomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var segmentController: UISegmentedControl!

    @IBOutlet weak var homeTableView: UITableView!
    var Arr_Main = NSMutableArray()
    var jobsArray = NSArray()
    var feedsArray = [LFFeedsData]()
    var refreshControl : UIRefreshControl!
    var isPageRefreshing = Bool()
    var page = String()
    var lastIndexPath = IndexPath()
    var isInitialLoad = Bool()
    let ref = FIRDatabase.database().reference(withPath: "POSTS")
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.setNavigationProperties()
        self.registerCells()
        self.selectedTabBar()
        self.setSegmentProperties()
        self.addThePullTorefresh()
        page = "1"
        isInitialLoad = true
        self.serviceAPICall(PageNumber: page, PageSize: "10")
      NotificationCenter.default.addObserver(self, selector: #selector(LFHomeViewController.updatedFeed), name:NSNotification.Name(rawValue: "POST_TO_FEED"), object: nil)
        
    }
    
    //MARK: Segment
    func setSegmentProperties(){
        
    
       
        
    }
   
    func setNavigationProperties(){
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)

    }
    
    //MARK: Add The PullToRefresh
    
    func addThePullTorefresh(){
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.homeTableView.addSubview(self.refreshControl)
        //self.homeTableView.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
    }
    
     func refresh(sender:UIRefreshControl) {
        
                    self.feedsArray = [LFFeedsData]()
                    self.isInitialLoad = true
                    self.page = "1"

            self.serviceAPICall(PageNumber: self.page, PageSize: "5")

        

    }
   
    func registerCells(){
        self.homeTableView.register(UINib(nibName: "LFHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHeaderTableViewCell")
        self.homeTableView.register(UINib(nibName: "LFHomeCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHomeCenterTableViewCell")
        self.homeTableView.register(UINib(nibName: "LFHomeFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHomeFooterTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     
    }
    
    func selectedTabBar(){
        
        let tabBar = self.tabBarController?.tabBar
        tabBar?.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: (tabBar?.frame.width)!/CGFloat((tabBar?.items!.count)!), height: (tabBar?.frame.height)!), lineWidth: 3.0)
    }
    
    func updatedFeed(){
        //print("Feed Updated")
        self.serviceAPICall(PageNumber: "1", PageSize: "10")
    }
    
    //MARK: calling home data from service
    func serviceAPICall(PageNumber: String, PageSize: String)
    {
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        LFDataManager.sharedInstance.getTheHomeFeed(pageNumber: PageNumber, pageSize: PageSize, userEmail: CXAppConfig.sharedInstance.getEmailID()) { (resultFeeds) in
            self.isPageRefreshing = false
            
            let lastIndexOfArr = self.feedsArray.count - 1
            if !resultFeeds.isEmpty {
                self.feedsArray.append(contentsOf: resultFeeds)
                
                // if it is Initial Load
                if self.isInitialLoad {
                    self.homeTableView.reloadData()
                } else {
                    // if using page nation
                    let indexArr = NSMutableArray()
                    let indexSet = NSMutableIndexSet()
                    
                    for i in 1...resultFeeds.count {
                        let index = IndexPath.init(row: 1, section: lastIndexOfArr + i)
                        indexSet.add(lastIndexOfArr + i)
                        indexArr.add(index)
                    }
                        self.homeTableView.beginUpdates()
                        self.homeTableView.insertSections(indexSet as IndexSet, with: .none)
                        self.homeTableView.insertRows(at: (indexArr as NSArray) as! [IndexPath], with: .none)
                        self.homeTableView.endUpdates()
                }

            }
            
            self.refreshControl.endRefreshing()
        }
 
    }
    
    //MARK: TableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.feedsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       return 3
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.feedsArray.count == 0 {
            let cell = UITableViewCell()
            return cell
        }
        
        let feeds = self.feedsArray[indexPath.section]

        //tableView.sel
        //let Dict_Detail = self.Arr_Main.object(at: indexPath.section) as AnyObject
        if indexPath.row == 0 {
            
          let  cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHeaderTableViewCell", for: indexPath)as? LFHeaderTableViewCell)!
            cell.lbl_Title.text = feeds.feedUserName
            cell.cafeNameLbl.text = feeds.feedIDMallName
            cell.postedTime.text = feeds.feedCreatedDate.timeAgoSinceDate(numericDates: true)
            cell.userPicImg.setImageWith(NSURL(string: feeds.feedUserImage) as URL!, usingActivityIndicatorStyle: .white)
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.row == 1 {
            let  cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHomeCenterTableViewCell", for: indexPath)as? LFHomeCenterTableViewCell)!
            let img_Url_Str = feeds.feedImage
            let img_Url = NSURL(string: img_Url_Str )
            cell.ImgView_Logo.setImageWith(img_Url as URL!, usingActivityIndicatorStyle: .white)
            cell.selectionStyle = .none
            return cell
        }else  {
          let  cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHomeFooterTableViewCell", for: indexPath)as? LFHomeFooterTableViewCell)!
//            cell.selectionStyle = .none
//            cell.alertBtn.addTarget(self, action: #selector(actionAlertSheet), for: .touchUpInside)
            cell.commentsBtn.addTarget(self, action: #selector(commentsBtnAction), for: .touchUpInside)
            lastIndexPath = indexPath
            
            let realm = try! Realm()
            let predicate = NSPredicate.init(format: "feedID=%@", feeds.feedID)
            
            let userData = realm.objects(LFHomeFeeds.self).filter(predicate)
            let data = userData.first
            
            let likeData = realm.objects(LFLikes.self).filter("jobId=='\(feeds.feedID)'")
            
            if likeData.count == 0 {
                cell.likeBtn.isSelected = false
            }
            else {
                cell.likeBtn.isSelected = true
            }
            
            cell.likesLabel.text = (data?.feedLikesCount)! + " Likes"
            cell.commentsLabel.text = (data?.feedCommentsCount)! + " Comments"
            cell.favouritesLabel.text = (data?.feedFavaouritesCount)! + " Favorites"
            
            cell.selectionStyle = .none
            cell.alertBtn.addTarget(self, action: #selector(actionAlertSheet), for: .touchUpInside)
            
            cell.likeBtn.addTarget(self, action: #selector(likeBtnAction), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.section
            
            lastIndexPath = indexPath
            
            return cell
        }
    
        
    }
    
    
   /*
    func didTapAddButton(sender: AnyObject) {
        let count = self.Arr_Main.count
        var indexPaths = [NSIndexPath]()
        
        // add two rows to my model that `UITableViewDataSource` methods reference;
        // also build array of new `NSIndexPath` references
        
        for row in count ..< count + 2 {
            self.Arr_Main.append("New row \(row)")
            self.Arr_Main.add(<#T##anObject: Any##Any#>)
            indexPaths.append(NSIndexPath(forRow: row, inSection: 0))
        }
        
        // now insert and scroll
        
        self.homeTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
        self.homeTableView.scrollToRowAtIndexPath(indexPaths.last!, atScrollPosition: .Bottom, animated: true)
    }
    */
    //MARK: TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
      //  let viewcontroller:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFFoodDetailViewController")as UIViewController
        //self.present(viewcontroller, animated: true, completion: nil)
        
        if indexPath.row == 0
        {
            
            //let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFRestaurentDetailsViewController")as! LFRestaurentDetailsViewController
          //  self.navigationController?.pushViewController(storyboard, animated: true)
            
        }
        
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
    
    //MARK: TableView Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == homeTableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                print("scroll did reached down")
                if isPageRefreshing == false {
                    isPageRefreshing=true
                    var num = Int(page)
                    num = num! + 1
                    page = "\(num!)"
                    isInitialLoad = false
                    self.serviceAPICall(PageNumber: page, PageSize: "5")
                    
                }
                
            }
        }
    }
    
    @IBAction func Segment_Clicked(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            UIView.transition(with: self.homeTableView, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: nil, completion: nil)
           // (sender.subviews[0] as UIView).tintColor = UIColor.black
            

           // print("Home selected")
        //show popular view
        case 1:
            
          //  print("near selected")
    
           // (sender.subviews[0] as UIView).tintColor = UIColor.black
            UIView.transition(with: self.homeTableView, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromRight, animations: nil, completion: nil)
            
        //show history view
        default:
            break;
        }
        
    }
    

   

}


extension LFHomeViewController{
    func actionAlertSheet()
    {
        
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Flag/Report", style: .destructive, handler: { (action) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFFlagReportViewController")as? LFFlagReportViewController
            self.navigationController?.pushViewController(storyboard!, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Add to Favorites List", style: .default, handler: { (action) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Share to Facebook", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Share to Twitter", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Copy Share URL", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func commentsBtnAction(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFCommentViewViewController")as? LFCommentViewViewController
        storyboard?.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.keyWindow?.rootViewController?.present(storyboard!, animated: true, completion: nil)
    }
    
    
    func likeBtnAction(sender:UIButton)
    {
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading..")
        let feeds = self.feedsArray[sender.tag]
        


        if sender.isSelected {
            LFDataManager.sharedInstance.getPostLike(orgID: feeds.feedIDMallID, jobID:feeds.feedID, isLike: false, completion: {(result,resultDic) in
                
                if result {
                    sender.isSelected = false
                    let relamInstance = try! Realm()
                    print(resultDic.value(forKey: "jobId") as Any)
                    let userData = relamInstance.objects(LFLikes.self).filter("jobId=='\(resultDic.value(forKey: "jobId")!)'")
                    let like = userData.first
                    try! relamInstance.write({
                        
                        relamInstance.delete(like!)
                        
                    })
                }
                
                
            })
        }
        else {
            LFDataManager.sharedInstance.getPostLike(orgID: feeds.feedIDMallID, jobID:feeds.feedID, isLike: true, completion: {(result,resultDic) in
                
                if result {
                    sender.isSelected = true
                    let relamInstance = try! Realm()
                    let userData = relamInstance.objects(LFLikes.self).filter("jobId=='\(resultDic.value(forKey: "jobId"))'")
                    if userData.count == 0 {
                        
                        try! relamInstance.write({
                            let like = LFLikes()
                            like.jobId = resultDic.value(forKey: "jobId") as! String
                            relamInstance.add(like)
                        })
                        
                    }
                }
                
                
            })
        }
    }
    
}








