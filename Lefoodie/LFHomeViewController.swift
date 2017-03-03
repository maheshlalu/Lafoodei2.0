
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
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Social
class LFHomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FirebaseDelegate {
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
    
    var visiblePostID : String!
    var visibleIndex : Int!

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
        self.feedsArray = [LFFeedsData]()
        self.isInitialLoad = true
        self.page = "1"
        self.serviceAPICall(PageNumber: page, PageSize: "10")
    }
    
    
    func deleteTheFeedsInDatabase(){
        
        if page == "1" {
            let relamInstance = try! Realm()
            let feedData = relamInstance.objects(LFHomeFeeds.self)
            try! relamInstance.write({
                relamInstance.delete(feedData)
            })
            
            let likesData = relamInstance.objects(LFLikes.self)
            try! relamInstance.write({
                relamInstance.delete(likesData)
            })
            
        }
   
    }
    
    //MARK: calling home data from service
    func serviceAPICall(PageNumber: String, PageSize: String)
    {
        self.deleteTheFeedsInDatabase()
        LFFireBaseDataService.sharedInstance.firebaseDataDelegate = self
        LFFireBaseDataService.sharedInstance.addPostObserver()
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
        self.visiblePostID = feeds.feedID
        self.visibleIndex = indexPath.section
       // LFFireBaseDataService.sharedInstance.addPostActivity(isUpdateComment: true, isLikeCount: true, isFavorites: true, postID: feeds.feedID)
        if indexPath.row == 0 {
          let  cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHeaderTableViewCell", for: indexPath)as? LFHeaderTableViewCell)!
            cell.papulateUserinformation(feedData: feeds)
            let userNameGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userLabelAction))
            cell.lbl_Title.addGestureRecognizer(userNameGestureRecognizer)
            
            let userRestaurantGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userRestaurantAction))
            cell.cafeNameLbl.addGestureRecognizer(userRestaurantGestureRecognizer)
            return cell
        }else if indexPath.row == 1 {
            let  cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHomeCenterTableViewCell", for: indexPath)as? LFHomeCenterTableViewCell)!
            cell.papulateImageData(feedData: feeds)
            return cell
        }else  {
          let  cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHomeFooterTableViewCell", for: indexPath)as? LFHomeFooterTableViewCell)!
            cell.commentsBtn.addTarget(self, action: #selector(commentsBtnAction), for: .touchUpInside)
            cell.commentsBtn.tag = indexPath.section
            lastIndexPath = indexPath
            
            cell.papulatedData(feedData: feeds)
            cell.alertBtn.addTarget(self, action: #selector(actionAlertSheet), for: .touchUpInside)
            cell.alertBtn.tag = indexPath.section
            
            cell.likeBtn.addTarget(self, action: #selector(likeBtnAction), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.section
            lastIndexPath = indexPath
            return cell
        }
    
        
    }
    
    
    func userLabelAction(){
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileContoller : LFUserProfileViewController = (storyBoard.instantiateViewController(withIdentifier: "LFUserProfileViewController") as? LFUserProfileViewController)!
        profileContoller.screenVal = "User"
        self.navigationController?.pushViewController(profileContoller, animated: true)
    }
    
    func userRestaurantAction(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileContoller : LFUserProfileViewController = (storyBoard.instantiateViewController(withIdentifier: "LFUserProfileViewController") as? LFUserProfileViewController)!
        profileContoller.screenVal = "Restaurant"
        self.navigationController?.pushViewController(profileContoller, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let feeds = self.feedsArray[indexPath.section]
//        self.visiblePostID = feeds.feedID
//        self.visibleIndex = indexPath.row
//
//    }

    
    
    
    
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
            
//            let indexPath : NSIndexPath = NSIndexPath(row: 1, section: indexPath.section)
//
//            let cell: LFHomeCenterTableViewCell = tableView.cellForRow(at: indexPath as IndexPath) as! LFHomeCenterTableViewCell
//            
//            print( cell.ImgView_Logo.image?.size.width)
//            print( cell.ImgView_Logo.image?.size.height)

            
            return 320

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
    func actionAlertSheet(sender:UIButton)
    {
        let feeds = self.feedsArray[sender.tag]
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Flag/Report", style: .destructive, handler: { (action) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFFlagReportViewController")as? LFFlagReportViewController
            self.navigationController?.pushViewController(storyboard!, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Add to Favorites List", style: .default, handler: { (action) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Share to Facebook", style: .default, handler: { (action) in
            //publicURL
            let contentUrl = feeds.feedPublicUrl
            let contentTitle = feeds.feedName
            let contentDescription = feeds.feedDescription
            let contentImageUrl = feeds.feedImage
            
            let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: contentUrl) as URL!
            content.contentTitle = contentTitle
            content.contentDescription = contentDescription
            content.imageURL = NSURL(string:contentImageUrl) as URL!
            FBSDKShareDialog.show(from: self, with: content, delegate: nil)

            
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Tweet", style: .default, handler: { (action) in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterSheet.setInitialText(feeds.feedPublicUrl)
                self.present(twitterSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Copy Share URL", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func commentsBtnAction(sender:UIButton){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFCommentViewViewController")as? LFCommentViewViewController
        storyboard?.navigationController?.isNavigationBarHidden = false
        let feeds = self.feedsArray[sender.tag]
        storyboard?.feedData = feeds
        storyboard?.reloadSection = { _ in
            self.homeTableView.reloadSections(NSIndexSet(index: sender.tag) as IndexSet, with: .none);
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(storyboard!, animated: true, completion: nil)
    }
    
    
    func likeBtnAction(sender:UIButton)
    {
        
        
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading..")
        let feeds = self.feedsArray[sender.tag]
        if !sender.isSelected{
            LFDataManager.sharedInstance.getPostLike(orgID: feeds.feedIDMallID, jobID:feeds.feedID, isLike: true, completion: {(result,resultDic) in
                if result {
                    self.updateFeedsData(feedID: feeds.feedID, respoceDic: resultDic)
                    sender.isSelected = true
                    let relamInstance = try! Realm()
                    let userData = relamInstance.objects(LFLikes.self).filter("jobId=='\(resultDic.value(forKey: "jobId"))'")
                    if userData.count == 0 {
                        try! relamInstance.write({
                            let like = LFLikes()
                            like.jobId = resultDic.value(forKey: "jobId") as! String
                            relamInstance.add(like)
                            self.homeTableView.reloadSections(NSIndexSet(index: sender.tag) as IndexSet, with: .none);
                        })
                        
                    }
                }
                
                
            })
        
    }
    

    }
}



extension LFHomeViewController{
    
    func updateFeedsData(feedID:String,respoceDic:NSDictionary){
        //Update The like count in firebase
        
        
        LFFireBaseDataService.sharedInstance.updateThepostDetails(isUpdateComment: false, isLikeCount: true, isFavorites: false, postID: feedID,likeCount:String(describing: respoceDic.value(forKey: "count")!) )

        let realm = try! Realm()
        let predicate = NSPredicate.init(format: "feedID=%@", feedID)
        let userData = realm.objects(LFHomeFeeds.self).filter(predicate).first
            try! realm.write {
            userData?.feedLikesCount = String(describing: respoceDic.value(forKey: "count")!)
 
        }
    }
}


//MARK: FIRBASE Listener


extension LFHomeViewController{

    func calledTheFirebaseListener(postID:String){
        if postID == self.visiblePostID {
            //Reload The Visible Section in  Tableview
            self.homeTableView.reloadSections(NSIndexSet(index: self.visibleIndex) as IndexSet, with: .none);
        }
    }
    
}


/*
 
 issues
 number of sections contained in the table view after the update (1) must be equal to the number of sections contained in the table view before the update (1), plus or minus the number of sections inserted or deleted (1 inserted, 0 deleted).'
 *** First throw call stack:
 */




