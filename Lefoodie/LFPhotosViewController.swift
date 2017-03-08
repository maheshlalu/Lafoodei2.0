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
    var isMyPosts : Bool = true
    var userEmail :String!
    var subAdminId: String!
    var photosList = [LFFeedsData]()
    var userPhotosList : Results<LFUserPhotos>!

    
    var intrinsicContentSize: CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 180, right: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        photoCollectionView.setContentOffset(CGPoint.zero, animated: true)
        
        let nib = UINib(nibName: "LFPhotoCollectionViewCell", bundle: nil)
        self.photoCollectionView.register(nib, forCellWithReuseIdentifier: "LFPhotoCollectionViewCell")
        self.view.backgroundColor = UIColor.white
        if self.title == "PHOTOS" {
            self.getTheUserPostedPhots(email: userEmail, isMyposts: isMyPosts)
        }else {
            getTheRestaurantFoodiePhotos(id: subAdminId)
        }
        

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isMyPosts {
            if (self.userPhotosList != nil) {
                return self.userPhotosList.count
            }
            return 0
        }else{
            return self.photosList.count
 
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
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
    func getTheUserPostedPhots(email:String,isMyposts:Bool){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        LFDataManager.sharedInstance.getUserPosts(userEmail: email, myPosts: true, pageNumber: "", pageSize: "") { (isSaved, feedsResults) in
            CXDataService.sharedInstance.hideLoader()
            if isMyposts {
                let realm = try! Realm()
                self.userPhotosList = realm.objects(LFUserPhotos.self)
            }else{
                self.photosList = feedsResults;
            }
            self.photoCollectionView.reloadData()
        }
    }
    
   //http://35.160.251.153:8081/Services/getMasters?type=User%20Posts&mallId=2&consumerId=6&myJobs=true
    func getTheRestaurantFoodiePhotos(id:String){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getMasterUrl(), parameters: ["type":"User Posts" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject, "consumerId":id as AnyObject, "myJobs":"true" as AnyObject]) { (responseDict) in
            CXDataService.sharedInstance.hideLoader()
            let orgs : NSArray = (responseDict.value(forKey: "jobs") as?NSArray)!
            var feedsList = [LFFeedsData]()
            for resData in orgs{
                let restaurants = LFFeedsData(json:JSON(resData))
                feedsList.append(restaurants)
            }
            print(feedsList, feedsList.count)
            self.photosList = feedsList
            self.photoCollectionView.reloadData()
            
            //macIdInfodetails
            
//            var restarurantsLists = [Restaurants]()
//            for resData in orgs{d
//                let restaurants = Restaurants(json: JSON(resData))
//                restarurantsLists.append(restaurants)
//            }
            
        }
        
        
        //LFDataManager.sharedInstance.getUserPosts(userEmail: id, myPosts: true, pageNumber: "", pageSize: "") { (isSaved, feedsResults) in
            //            CXDataService.sharedInstance.hideLoader()
            //            if isMyposts {
            //                let realm = try! Realm()
            //                self.userPhotosList = realm.objects(LFUserPhotos.self)
            //            }else{
            //                self.photosList = feedsResults;
            //            }
            //            self.photoCollectionView.reloadData()
        //}
        
    }
}


