//
//  LFPhotosViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 03/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class LFPhotosViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITabBarControllerDelegate {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!

    var canScrollToTop:Bool = true
    var lastContentOffse:CGPoint = CGPoint()
    var parantNavigationController = UINavigationController()
    var isMyPosts : Bool = Bool()
    var isOtherUserPosts : Bool = false
    var userEmail :String!
    var subAdminId: String!
    var photosList = [LFFeedsData]()
    var userPhotosList : Results<LFUserPhotos>!
    var refreshControl : UIRefreshControl!
    var isPageRefreshing = Bool()
    var page = String()
    var lastIndexPath = IndexPath()
    var isInitialLoad = Bool()

    var intrinsicContentSize: CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 180, right: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        photoCollectionView.setContentOffset(CGPoint.zero, animated: true)
        photoCollectionView.isPagingEnabled = true
        
        let nib = UINib(nibName: "LFPhotoCollectionViewCell", bundle: nil)
        self.photoCollectionView.register(nib, forCellWithReuseIdentifier: "LFPhotoCollectionViewCell")
        self.view.backgroundColor = UIColor.white
        
        if self.title == "PHOTOS" {
            if isOtherUserPosts{
                self.getTheUserPostedPhots(email: userEmail, isMyposts: true, isUserPosts: true)
            }else{
                self.getTheUserPostedPhots(email: userEmail, isMyposts: isMyPosts, isUserPosts: false)
            }
        }else {
            addThePullTorefresh()
            isMyPosts = false
            page = "1"
            isInitialLoad = true
            self.serviceAPICall(id:subAdminId ,PageNumber: page, PageSize: "10")
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if isMyPosts {
            if (self.userPhotosList != nil) {
                return self.userPhotosList.count
            }
            return 0
        }else{
            return self.photosList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:LFPhotoCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "LFPhotoCollectionViewCell", for: indexPath)as? LFPhotoCollectionViewCell)!
        
        if isMyPosts {
            let myPhotos : LFUserPhotos = self.userPhotosList[indexPath.item]
            cell.photoiImg.setImageWith(NSURL(string: myPhotos.feedImage) as URL!, usingActivityIndicatorStyle: .white)
        }else{
            let feed : LFFeedsData = self.photosList[indexPath.item]
            cell.photoiImg.setImageWith(NSURL(string: feed.feedImage) as URL!, usingActivityIndicatorStyle: .white)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/2-10,height: 150)
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFItemDetailViewController")as? LFItemDetailViewController
        self.parantNavigationController.pushViewController(storyboard!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        canScrollToTop = true
    }
    
    // Called when the view becomes unavailable
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canScrollToTop = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        if self.title == "PHOTOS" {
        }else {
            if scrollView == photoCollectionView{
                
                if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
                {
                    print("scroll did reached down")
                    if isPageRefreshing == false {
                        isPageRefreshing=true
                        var num = Int(page)
                        num = num! + 1
                        page = "\(num!)"
                        isInitialLoad = false
                        self.serviceAPICall(id:subAdminId,PageNumber: page, PageSize: "10")
                    }
                    
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset: CGPoint = scrollView.contentOffset
        if currentOffset.y >= 0 {
           // print("UP")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollUp"), object: nil)
        }
        else {
           // print("Down")
            //ScrollDown
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ScrollDown"), object: nil)
        }
        self.lastContentOffse = currentOffset
    }
}


extension LFPhotosViewController{
    //http://35.163.183.25:8081/MobileAPIs/getUserPosts?email=yasaswy.gunturi@gmail.com&myPosts=true
    func getTheUserPostedPhots(email:String,isMyposts:Bool,isUserPosts:Bool){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        LFDataManager.sharedInstance.getUserPosts(userEmail: email, myPosts: isMyposts, otherPosts:isUserPosts, pageNumber: "", pageSize: "") { (isSaved, feedsResults) in
            CXDataService.sharedInstance.hideLoader()
            if isMyposts && !isUserPosts {
                let realm = try! Realm()
                self.userPhotosList = realm.objects(LFUserPhotos.self)
            }else{
                self.photosList = feedsResults;
            }
            self.photoCollectionView.reloadData()
        }
    }
    
    func deleteTheFeedsInDatabase(){
        if page == "1" {
            let relamInstance = try! Realm()
            let feedData = relamInstance.objects(LFHomeFeeds.self)
            try! relamInstance.write({
                relamInstance.delete(feedData)
            })
        }
    }
    
    func addThePullTorefresh(){
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.photoCollectionView.addSubview(self.refreshControl)
        //self.homeTableView.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
    }
    
    func refresh(sender:UIRefreshControl) {
        self.photosList = [LFFeedsData]()
        self.isInitialLoad = true
        self.page = "1"
        self.serviceAPICall(id:subAdminId,PageNumber: page, PageSize: "10")
    }
    
    func serviceAPICall(id:String,PageNumber: String, PageSize: String){
        self.deleteTheFeedsInDatabase()
        
        LFDataManager.sharedInstance.getTheRFoodiePhotoFeed(id: subAdminId, pageNumber: PageNumber, pageSize: PageSize) { (resultFeeds) in
            self.isPageRefreshing = false
            let lastIndexOfArr = self.photosList.count - 1
            if !resultFeeds.isEmpty {
                self.photosList.append(contentsOf: resultFeeds)
                
                // if it is Initial Load
                if self.isInitialLoad {
                    self.photoCollectionView.reloadData()
                } else {
                    // if using page nation
                    let indexArr = NSMutableArray()
                    let indexSet = NSMutableIndexSet()
                    
                    for i in 1...resultFeeds.count {
                        let index = IndexPath.init(row: 1, section: lastIndexOfArr + i)
                        indexSet.add(lastIndexOfArr + i)
                        indexArr.add(index)
                    }
                    print(indexArr.description)
                    print(indexSet)
                    self.photoCollectionView.reloadData()
                    //self.photoCollectionView.insertItems(at:indexArr as [IndexPath])
                }
            }
            CXDataService.sharedInstance.hideLoader()
        }
    }
}


