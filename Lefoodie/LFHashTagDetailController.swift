//
//  LFHashTagDetailController.swift
//  Lefoodie
//
//  Created by SRINIVASULU on 14/03/17.
//  Copyright © 2017 ongo. All rights reserved.
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

class LFHashTagDetailController: UIViewController,UITableViewDataSource,UITableViewDelegate,FirebaseDelegate {
    var hashTagNamestr: NSString = String() as NSString
     @IBOutlet weak var hashTagTableView: UITableView!
    var hashTagArray = [LFFeedsData]()
    var lastIndexPath = IndexPath()
    var isInitialLoad = Bool()
    var isPageRefreshing = Bool()
    var refreshControl : UIRefreshControl!
    var visiblePostID : String!
    var visibleIndex : Int!
     var myProfile : LFMyProfile!
     var foodiesArr : Results<LFFoodies>!
    var page = String()
    var LFTabHomeController:LFTabHomeController!
    
    @IBOutlet weak var noDataLabel: UILabel!
    override func viewDidLoad() {
        self.navigationItem.title = hashTagNamestr as String
        hashTagNamestr = hashTagNamestr.replacingOccurrences(of: "#", with: "") as NSString
        print("Hashtag \(hashTagNamestr)")
        
        super.viewDidLoad()
        //self.setNavigationProperties()
        self.registerCells()
        self.addThePullTorefresh()
        self.getHashTagDataFromService(PageNumber: "", PageSize: "", HashTag: hashTagNamestr as String)
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        //self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func registerCells(){
        self.hashTagTableView.register(UINib(nibName: "LFHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHeaderTableViewCell")
        self.hashTagTableView.register(UINib(nibName: "LFHomeCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHomeCenterTableViewCell")
        self.hashTagTableView.register(UINib(nibName: "LFHomeFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHomeFooterTableViewCell")
    }
    
    
//    func setNavigationProperties(){
//        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
//        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
//        
//    }
    
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
    //MARK: Add The PullToRefresh
    
    func addThePullTorefresh(){
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.hashTagTableView.addSubview(self.refreshControl)
        //self.homeTableView.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
    }
    
    func refresh(sender:UIRefreshControl) {
        self.hashTagArray = [LFFeedsData]()
        self.isInitialLoad = true
        self.page = "1"
        
      self.getHashTagDataFromService(PageNumber: "", PageSize: "", HashTag: "")
    }

    
    
    //MARK: TableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.hashTagArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.hashTagArray.count == 0 {
            let cell = UITableViewCell()
            return cell
        }
        
        let feeds = self.hashTagArray[indexPath.section]
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
            //cell.photoDescriptionLbl.text = "wanderireland@travelingspud got a front row seat to one of #Ireland 's most famous views #TheCliffsofMoher - #irlande #Ireland #irland #irlanda #discoverireland #Wanderireland - Watch "
            cell.photoDescriptionLbl.hashtagLinkTapHandler = { label, hashtag, range in
                
                self.hashTagTapped(hashTagName: hashtag)
            }
            
            return cell
        }
    }
    
    func hashTagTapped(hashTagName:String){
        self.navigationItem.title = hashTagName as String
        var removeHashTag: NSString = hashTagName as NSString
        removeHashTag = removeHashTag.replacingOccurrences(of: "#", with: "") as NSString
        self.hashTagArray = [LFFeedsData]()
         self.getHashTagDataFromService(PageNumber: "", PageSize: "", HashTag: removeHashTag as String)
        self.hashTagTableView.reloadData()
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }else if indexPath.row == 1 {
            return 320
        }else if indexPath.row == 2 {
            return 100
        }
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        //self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        let menuItem = UIBarButtonItem(image: UIImage(named: "leftArrow"), style: .plain, target: self, action: #selector(LFHashTagDetailController.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    func backBtnClicked()
    {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Get Hashtag data 
    func getHashTagDataFromService(PageNumber: String,PageSize:String,HashTag:String){
    self.deleteTheFeedsInDatabase()
        LFFireBaseDataService.sharedInstance.firebaseDataDelegate = self
        LFFireBaseDataService.sharedInstance.addPostObserver()
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        LFDataManager.sharedInstance.getTheHAshTagDataFromServer(PageNumber: PageNumber, PageSize: PageSize, HashTag: HashTag){ (resultFeeds) in
            self.isPageRefreshing = false
            let lastIndexOfArr = self.hashTagArray.count - 1
            if !resultFeeds.isEmpty {
                self.hashTagArray.append(contentsOf: resultFeeds)
                
                print("nearByFeed Count\(self.hashTagArray.count)")
                
                
                // if it is Initial Load
                if self.isInitialLoad {
                    self.hashTagTableView.reloadData()
                } else {
                    // if using page nation
                    let indexArr = NSMutableArray()
                    let indexSet = NSMutableIndexSet()
                    
                    for i in 1...resultFeeds.count {
                        let index = IndexPath.init(row: 1, section: lastIndexOfArr + i)
                        indexSet.add(lastIndexOfArr + i)
                        indexArr.add(index)
                    }
                    self.hashTagTableView.beginUpdates()
                    self.hashTagTableView.insertSections(indexSet as IndexSet, with: .none)
                    self.hashTagTableView.insertRows(at: (indexArr as NSArray) as! [IndexPath], with: .none)
                    self.hashTagTableView.endUpdates()
                }
                
            }else{
            self.hashTagTableView.isHidden = true
                self.noDataLabel.isHidden = false
            }
            
            self.refreshControl.endRefreshing()
            self.hashTagTableView.reloadData()
        }
    }
    
    func userLabelAction(sender: UITapGestureRecognizer){
        
        let realm = try! Realm()
        self.myProfile = realm.objects(LFMyProfile.self).first
        let feeds = self.hashTagArray[(sender.view?.tag)!]
        
        let predicate = NSPredicate.init(format:"foodieEmail==%@", feeds.feedUserEmail)
        self.foodiesArr = realm.objects(LFFoodies.self).filter(predicate)
        
        if myProfile.userEmail == feeds.feedUserEmail{
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let profileContoller : LFUserProfileViewController = (storyBoard.instantiateViewController(withIdentifier: "LFUserProfileViewController") as? LFUserProfileViewController)!
            profileContoller.profileDetails = ProfileDetailsType.userType
            LFDataManager.sharedInstance.dataManager().selectedIndex = 4
            
        }else{
            
            let restaurentView = self.storyboard!.instantiateViewController(withIdentifier: "LFRestaurentDetailsViewController") as! LFRestaurentDetailsViewController
            restaurentView.foodiesArr = self.foodiesArr
            restaurentView.isFromHome = true
            
            let navController = UINavigationController(rootViewController: restaurentView)
            navController.navigationItem.hidesBackButton = false
            
            //            LFDataManager.sharedInstance.sendTheFollwAndUnFollowPushNotification(isFollow: true, foodieDetails:dict!)
            
            self.present(navController, animated:true, completion: nil)
        }
        
    }
    func userRestaurantAction(sender: UITapGestureRecognizer){
        let feeds = self.hashTagArray[(sender.view?.tag)!]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileContoller : LFUserProfileViewController = (storyBoard.instantiateViewController(withIdentifier: "LFUserProfileViewController") as? LFUserProfileViewController)!
        profileContoller.profileDetails = ProfileDetailsType.restaurantsType
        profileContoller.subAminId = feeds.feedIDMallID
        profileContoller.rEmail = feeds.feedIDMallEmail
        profileContoller.isFromHome = true
        self.navigationController?.pushViewController(profileContoller, animated: true)
    }
    
}
    extension LFHashTagDetailController{
        func actionAlertSheet(sender:UIButton)
        {
            let realm = try! Realm()
            self.myProfile = realm.objects(LFMyProfile.self).first
            let feeds = self.hashTagArray[sender.tag]
            
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
            
            if myProfile.userEmail == feeds.feedUserEmail{
                //
                alert.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (action) in
                    //http://35.160.251.153:8081/jobs/jobToDelete? jobId =1748
                    //{"myHashMap":{"status":"1","success":"Successfully deleted"}}
                    CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.deletePostOfUser(), parameters: ["jobId":feeds.feedID as AnyObject]) { (responseDict) in
                        print(responseDict)
                        let status: Int = Int(responseDict.value(forKeyPath: "myHashMap.status") as! String)!
                        if status == 1{
                            self.showAlert("", status: status)
                            //self.homeTableView.deleteSections([sender.tag] as IndexSet, with: .none)
                            self.hashTagTableView.reloadData()
                            
                        }else{
                            print("something went wrong")
                        }
                    }
                }))
            }
            self.present(alert, animated: true, completion: nil)
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
            let feeds = self.hashTagArray[sender.tag]
            storyboard?.feedData = feeds
            storyboard?.reloadSection = { _ in
                self.hashTagTableView.reloadSections(NSIndexSet(index: sender.tag) as IndexSet, with: .none);
            }
            self.present(storyboard!, animated: true, completion: nil)
        }
        
        
        func likeBtnAction(sender:UIButton)
        {
            CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading..")
            let feeds = self.hashTagArray[sender.tag]
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
                                self.hashTagTableView.reloadSections(NSIndexSet(index: sender.tag) as IndexSet, with: .none);
                            })
                        }
                    }
                })
            }
        }
        
    }
    
    

extension LFHashTagDetailController{
    
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

extension LFHashTagDetailController{
    
    func calledTheFirebaseListener(postID:String){
        if postID == self.visiblePostID {
            //Reload The Visible Section in  Tableview
            self.hashTagTableView.reloadSections(NSIndexSet(index: self.visibleIndex) as IndexSet, with: .none);
        }
    }
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


