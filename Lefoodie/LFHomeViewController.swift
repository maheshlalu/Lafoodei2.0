
//
//  LFHomeViewController.swift
//  Lefoodie
//1003573  7382142492
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
import MapKit

class LFHomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FirebaseDelegate,CLLocationManagerDelegate {
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
    var myProfile : LFMyProfile!
    var foodiesArr : Results<LFFoodies>!
    var visiblePostID : String!
    var visibleIndex : Int!
    var LFTabHomeController:LFTabHomeController!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var isNearByFeed: Bool = false

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setNavigationProperties()
        self.registerCells()
        self.selectedTabBar()
        self.addThePullTorefresh()
        page = "1"
        LFDataManager.sharedInstance.getHashTagDataFromServer()
        LFDataManager.sharedInstance.getUserNamesDataFromServer()
        isInitialLoad = true
        self.serviceAPICall(PageNumber: page, PageSize: "10")
        NotificationCenter.default.addObserver(self, selector: #selector(LFHomeViewController.updatedFeed), name:NSNotification.Name(rawValue: "POST_TO_FEED"), object: nil)
        locManager.requestWhenInUseAuthorization()
        
       self.homeTableView.rowHeight = UITableViewAutomaticDimension
        self.homeTableView.estimatedRowHeight = 100
        //
        
        
//        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//            currentLocation = locManager.location
////            print(currentLocation.coordinate.latitude)
////            print(currentLocation.coordinate.longitude)
//        }
        
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
        self.homeTableView.reloadData()
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
        self.serviceAPICall(PageNumber: page, PageSize: "5")
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
    
  //MARK: Checking location authentication
    func checklocationAuthentication(){
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
    }
    
    //MARK: calling home data from service
    func serviceAPICall(PageNumber: String, PageSize: String)
    {
        
        if isNearByFeed{
        //self.checklocationAuthentication()
            
            // checking location authentication
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                currentLocation = locManager.location
                if currentLocation != nil{
                    let lat: Double = currentLocation.coordinate.latitude
                    let latstr: String = String(format:"%f", lat)
                    
                    let long: Double = currentLocation.coordinate.longitude
                    let longstr: String = String(format:"%f", long)
                    let neardbystr: String = latstr + "|" + longstr + "|" + "200"
                    LFFireBaseDataService.sharedInstance.firebaseDataDelegate = self
                    LFFireBaseDataService.sharedInstance.addPostObserver()
                    CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
                    //LFDataManager.sharedInstance.getTheHomeFeed(pageNumber: PageNumber, pageSize: PageSize, userEmail: CXAppConfig.sharedInstance.getEmailID(),isNearByFeed:true) { (resultFeeds) in
                    // sample test lat and long "36.976042| -121.582814|5"
                    LFDataManager.sharedInstance.getTheHomeFeed(pageNumber: PageNumber, pageSize: PageSize, userEmail: CXAppConfig.sharedInstance.getEmailID(), isNearByFeed: true, nearByMallsLatLong: neardbystr){ (resultFeeds) in
                        print(resultFeeds)
                        self.isPageRefreshing = false
                        CXDataService.sharedInstance.hideLoader()
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
                        self.homeTableView.reloadData()
                    }
                }else{
                
                }
            }else{
                self.showAlertView(status: 1)
                self.homeTableView.reloadData()
           // print("Not get lat and long data")
            }
    }else{
            self.deleteTheFeedsInDatabase()
            LFFireBaseDataService.sharedInstance.firebaseDataDelegate = self
            LFFireBaseDataService.sharedInstance.addPostObserver()
            CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
           // LFDataManager.sharedInstance.getTheHomeFeed(pageNumber: PageNumber, pageSize: PageSize, userEmail: CXAppConfig.sharedInstance.getEmailID(),isNearByFeed:false) { (resultFeeds) in
            LFDataManager.sharedInstance.getTheHomeFeed(pageNumber: PageNumber, pageSize: PageSize, userEmail: CXAppConfig.sharedInstance.getEmailID(), isNearByFeed: false, nearByMallsLatLong: ""){ (resultFeeds) in
                print(resultFeeds)
                
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
                    
                }else if self.page == "0"{
                    CXDataService.sharedInstance.hideLoader()
                    self.segmentController.selectedSegmentIndex = 1
                    self.isNearByFeed = true
                    self.updatedFeed()
                }
                self.refreshControl.endRefreshing()
                self.homeTableView.reloadData()
            }
        }
    }
    
    //MARK: AlertView for Locations
    func showAlertView(status:Int) {
        let alert = UIAlertController(title:"Turn On Location Services to Allow \"LeFoodies\" to Determine Your Location", message:"", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        let okAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
                
            }else{
                
            }
        }
       
        alert.addAction(okAction)
         alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        let currentLocation : CLLocation = newLocation
        
        
        print(" latitude \(currentLocation.coordinate.latitude)")
        print("longitude \(currentLocation.coordinate.longitude)")
       
        
    }
    
    //MARK: TableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.feedsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
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
            cell.lbl_Title.tag = indexPath.section
            lastIndexPath = indexPath
            cell.lbl_Title.addGestureRecognizer(userNameGestureRecognizer)
            
            cell.locationBtn.addTarget(self, action: #selector(userRestaurantLocatorAction(sender:)), for: .touchUpInside)
            cell.locationBtn.tag = indexPath.section
            lastIndexPath = indexPath
            
            let userRestaurantGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userRestaurantAction))
            cell.cafeNameLbl.tag = indexPath.section
            lastIndexPath = indexPath
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
            cell.photoDescriptionLbl.hashtagLinkTapHandler = { label, hashtag, range in
                self.hashTagTapped(hashTagName: hashtag)
            }
            
            cell.photoDescriptionLbl.userHandleLinkTapHandler = { label, handle, range in
                NSLog("User handle \(handle) tapped")
                self.userHandle(userhandleName: handle)
            }
            
            return cell
        }
    }
    //MARK: HashTag Button Tapped
    func hashTagTapped(hashTagName:String){
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let hashtagcontroller : LFHashTagDetailController = (storyBoard.instantiateViewController(withIdentifier: "LFHashTagDetailController") as? LFHashTagDetailController)!
        let navController = UINavigationController(rootViewController: hashtagcontroller)
        navController.navigationItem.hidesBackButton = false
        hashtagcontroller.hashTagNamestr = hashTagName
        self.present(navController, animated: true, completion: nil)
        
    }
    //MARK: User Handle (@username)

    func userHandle(userhandleName:String){
        print("user handle \(userhandleName) tapped")
        getAtUserDetails(userName: userhandleName)
    }
    
    //http://35.160.251.153:8081/MobileAPIs/getUserByUserName?username=babu
    func getAtUserDetails(userName:String){
        let userName = userName.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range:nil)
        // CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getAtUserDetails(), parameters: ["username":userName as AnyObject]) { (responseDict) in
            print(responseDict)
            //CXDataService.sharedInstance.hideLoader()
            let imgArr = responseDict.value(forKey:"jobs") as! NSArray
            let dict = imgArr[0] as? NSDictionary
            
            let userEmail = dict?.value(forKey: "Email") as! String
            
            let realm = try! Realm()
            self.myProfile = realm.objects(LFMyProfile.self).first
            
            let predicate = NSPredicate.init(format:"foodieEmail==%@",userEmail)
            self.foodiesArr = realm.objects(LFFoodies.self).filter(predicate)
            
            let restaurentView = self.storyboard!.instantiateViewController(withIdentifier: "LFRestaurentDetailsViewController") as! LFRestaurentDetailsViewController
            restaurentView.foodiesArr = self.foodiesArr
            restaurentView.isFromHome = true
            let navController = UINavigationController(rootViewController: restaurentView)
            navController.navigationItem.hidesBackButton = false
            self.present(navController, animated:true, completion: nil)
        }
    }
    
    func userLabelAction(sender: UITapGestureRecognizer){
        
        let realm = try! Realm()
        self.myProfile = realm.objects(LFMyProfile.self).first
        let feeds = self.feedsArray[(sender.view?.tag)!]
        
        if myProfile.userEmail == feeds.feedUserEmail{
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let profileContoller : LFUserProfileViewController = (storyBoard.instantiateViewController(withIdentifier: "LFUserProfileViewController") as? LFUserProfileViewController)!
            profileContoller.profileDetails = ProfileDetailsType.userType
            LFDataManager.sharedInstance.dataManager().selectedIndex = 4
            
        }else{
            let predicate = NSPredicate.init(format:"foodieEmail==%@", feeds.feedUserEmail)
            self.foodiesArr = realm.objects(LFFoodies.self).filter(predicate)
            
            if foodiesArr.count == 0{
                LFDataManager.sharedInstance.getTheParticularUserData(userEmail: feeds.feedUserEmail, completion: { (response) in
                    if response{
                        print(self.foodiesArr.description)
                        self.navigateToProfile()
                    }
                })
            }else{
                navigateToProfile()
            }
        }
    }
    
    func navigateToProfile(){
        let restaurentView = self.storyboard!.instantiateViewController(withIdentifier: "LFRestaurentDetailsViewController") as! LFRestaurentDetailsViewController
        restaurentView.foodiesArr = self.foodiesArr
        restaurentView.isFromHome = true
        let navController = UINavigationController(rootViewController: restaurentView)
        navController.navigationItem.hidesBackButton = false
        
        self.present(navController, animated:true, completion: nil)
    }
    
    
    func userRestaurantAction(sender: UITapGestureRecognizer){
        let feeds = self.feedsArray[(sender.view?.tag)!]
        userRestaurantCode(feeds: feeds)
    }
    
    func userRestaurantLocatorAction(sender: UIButton){
        let feeds = self.feedsArray[(sender.tag)]
        userRestaurantCode(feeds: feeds)
    }
    
    func userRestaurantCode(feeds:LFFeedsData){
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileContoller : LFUserProfileViewController = (storyBoard.instantiateViewController(withIdentifier: "LFUserProfileViewController") as? LFUserProfileViewController)!
        profileContoller.profileDetails = ProfileDetailsType.restaurantsType
        profileContoller.subAminId = feeds.feedIDMallID
        profileContoller.rEmail = feeds.feedIDMallEmail
        profileContoller.isFromHome = true
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
            
            
            return 250
            
        }else if indexPath.row == 2 {
            return UITableViewAutomaticDimension
            
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
        
        switch sender.selectedSegmentIndex{
        case 0:
            UIView.transition(with: self.homeTableView, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: nil, completion: nil)
            isNearByFeed = false
            self.isInitialLoad = true
            self.updatedFeed()
            //self.homeTableView.reloadData()
            
        case 1:
            // (sender.subviews[0] as UIView).tintColor = UIColor.black
            UIView.transition(with: self.homeTableView, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromRight, animations: nil, completion: nil)
            isNearByFeed = true
            self.updatedFeed()
            
        default:
            break;
        }
    }
}

//MARK: NearbyFeed Calling

extension LFHomeViewController{
    func actionAlertSheet(sender:UIButton)
    {
        let realm = try! Realm()
        self.myProfile = realm.objects(LFMyProfile.self).first
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
            let alert = UIAlertController.init(title: "", message: "Link Copied", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
                
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = feeds.feedPublicUrl
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        
        if myProfile.userEmail == feeds.feedUserEmail{
            //
            alert.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (action) in
                //http://35.160.251.153:8081/jobs/jobToDelete? jobId =1748
                //{"myHashMap":{"status":"1","success":"Successfully deleted"}}
               self.deletePost(feedId: feeds.feedID,sender: sender)

            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func deletePost(feedId:String,sender:UIButton){
        let alert = UIAlertController(title: "Are you sure?", message:"", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.deletePostOfUser(), parameters: ["jobId":feedId as AnyObject]) { (responseDict) in
                print(responseDict)
                let status: Int = Int(responseDict.value(forKeyPath: "myHashMap.status") as! String)!
                if status == 1{
                    self.homeTableView.beginUpdates()
                    self.feedsArray.remove(at: sender.tag)
                    let indexsset:IndexSet = [sender.tag]
                    self.homeTableView.deleteSections(indexsset, with: .fade)
                    self.homeTableView.endUpdates()

                    self.showAlert("", status: status)
                }else{
                    print("something went wrong")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
            
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion:nil)
    }
    
    func showAlert(_ message:String, status:Int) {
        let alert = UIAlertController(title: "Success!!!", message:"Post successfully deleted!!!" , preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alert.addAction(okAction)
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
        }else{
            CXDataService.sharedInstance.hideLoader()
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
        
        if (self.visiblePostID) != nil {
            if postID == self.visiblePostID {
                //Reload The Visible Section in  Tableview
                self.homeTableView.reloadSections(NSIndexSet(index: self.visibleIndex) as IndexSet, with: .none);
            }
        }
        
       
    }
    
}


