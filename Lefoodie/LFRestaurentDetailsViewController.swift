//
//  LFRestaurentDetailsViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import MagicalRecord
import RealmSwift

class LFRestaurentDetailsViewController: UIViewController,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var foodieBannerImgView: UIImageView!
    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var restaurantScrollView: UIScrollView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var foodieName: UILabel!
    @IBOutlet weak var foodieFollowLbl: UILabel!
    @IBOutlet weak var foodieImgView: UIImageView!
    var selectedFoodie : SearchFoodies!
    var foodiesArr : Results<LFFoodies>!
    var pageMenu : CAPSPageMenu?
    var tap: UITapGestureRecognizer?
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var myProfile : LFMyProfile!
    var isFromHome:Bool = Bool()
    var isAtTypeBool:Bool = Bool()
    
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var followBtn: CXButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        tabViews()
        foodieDetails()
        settingsBtn.isHidden = true
        editBtn.isHidden = true
        shareBtn.isHidden = true
        self.registerNotificaton()
        setUpFollowBtnStatus()
    }
    
    func setUpFollowBtnStatus()
    {
        let realm = try! Realm()
        var predicate : NSPredicate = NSPredicate()
        if isFromHome{
         predicate = NSPredicate.init(format: "followerUserId = %@ AND isFollowing=true", foodiesArr[0].foodieUserId)
        }else{
         predicate = NSPredicate.init(format: "followerUserId = %@ AND isFollowing=true", selectedFoodie.foodieUserId)
        }
        
        let  dataArray = realm.objects(LFFollowers.self).filter(predicate)
        if dataArray.count > 0 {
            followBtn.setTitle("UnFollow", for: .normal)
        }
    }
    
    func registerNotificaton(){
        NotificationCenter.default.addObserver(self, selector: #selector(LFUserProfileViewController.scrollUp), name:NSNotification.Name(rawValue: "scrollUp"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LFUserProfileViewController.scrollDown), name:NSNotification.Name(rawValue: "ScrollDown"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        let menuItem = UIBarButtonItem(image: UIImage(named: "leftArrow"), style: .plain, target: self, action: #selector(LFRestaurentDetailsViewController.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
    func backBtnClicked()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func foodieDetails(){
        
        if isFromHome{
            self.foodieName.text = foodiesArr[0].foodieName
            
            let imgUrl = URL(string: foodiesArr[0].foodieImage) as URL!
            let bannerImgUrl = URL(string: foodiesArr[0].foodieBannerImage) as URL!
            if imgUrl != nil{
                foodieImgView.setImageWith(imgUrl, usingActivityIndicatorStyle: .gray)
                foodieBannerImgView.setImageWith(bannerImgUrl, usingActivityIndicatorStyle:.gray)
            }else{
                foodieImgView.image = UIImage(named: "placeHolder")
                foodieBannerImgView.image = UIImage(named: "placeHolder")
            }
            
            let following = foodiesArr[0].foodieFollowingCount
            let follower = foodiesArr[0].foodieFollowerCount
            foodieFollowLbl.text = "\(follower) Followers . \(following) Following"
        }else{
            
            self.foodieName.text = selectedFoodie.foodieName
            
            let imgUrl = URL(string: selectedFoodie.foodieImage) as URL!
            let bannerImgUrl = URL(string: selectedFoodie.foodieBannerImage) as URL!
            if imgUrl != nil{
                foodieImgView.setImageWith(imgUrl, usingActivityIndicatorStyle: .gray)
                foodieBannerImgView.setImageWith(bannerImgUrl, usingActivityIndicatorStyle:.gray)
            }else{
                foodieImgView.image = UIImage(named: "placeHolder")
                foodieBannerImgView.image = UIImage(named: "placeHolder")
            }
            
            let realm = try! Realm()
            let predicate = NSPredicate.init(format: "foodieId=%@", selectedFoodie.foodieId)
            
            let userData = realm.objects(LFFoodies.self).filter(predicate)
            let data = userData.first
            
            let following = (data?.foodieFollowingCount)!
            let follower = (data?.foodieFollowerCount)!
            foodieFollowLbl.text = "\(follower) Followers . \(following) Following"
        }
        
        
    }
    
    
    @IBAction func settingBtnAction(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundlvarnil).instantiateViewController(withIdentifier: "LFItemDetailViewController")as? LFItemDetailViewController
        //        self.navigationController?.pushViewController(storyboard!, animated: true)
        
    }
    
    @IBAction func followBtnAction(_ sender: AnyObject) {
        
        if followBtn.titleLabel?.text == "Follow" {
            if isFromHome{
                followBtn.setTitle("UnFollow", for: .normal)
                LFDataManager.sharedInstance.followTheUser(foodieDetails: foodiesArr[0], isFromHome: true)
                self.updateFollwingCountInDB(type: "Increment")
            }else{
                followBtn.setTitle("UnFollow", for: .normal)
                LFDataManager.sharedInstance.followTheUser(foodieDetails: selectedFoodie, isFromHome: false)
                self.updateFollwingCountInDB(type: "Increment")
            }
            
        }
        else {
            if isFromHome{
                followBtn.setTitle("Follow", for: .normal)
                LFDataManager.sharedInstance.unFollowTheUser(foodieDetails: foodiesArr[0],isFromHome: true)
                self.updateFollwingCountInDB(type: "Decrement")
            }else{
                followBtn.setTitle("Follow", for: .normal)
                LFDataManager.sharedInstance.unFollowTheUser(foodieDetails: selectedFoodie,isFromHome: false)
                self.updateFollwingCountInDB(type: "Decrement")
            }
        }
    }
    
    func updateFollwingCountInDB(type:String)
    {
        let realm = try! Realm()
        self.myProfile = realm.objects(LFMyProfile.self).first
        var data:LFFoodies = LFFoodies()
        if isFromHome{
            data = foodiesArr[0]
        }else{
            let predicate = NSPredicate.init(format: "foodieId=%@", selectedFoodie.foodieId)
            let userData = realm.objects(LFFoodies.self).filter(predicate)
            data = userData.first!
        }
        
        
        if type == "Increment" {
            
            try! realm.write {
                //updating count in myprofile
                var count =  Int(self.myProfile.userFollwing)
                count = count! + 1
                self.myProfile.userFollwing =  "\(count!)"
                
                //updating count in FeedsData
                var cnt = Int((data.foodieFollowingCount))
                cnt = cnt! + 1
                data.foodieFollowingCount = "\(cnt!)"
                
                //updating local label
                foodieFollowLbl.text = "\((data.foodieFollowerCount)) Followers . \(cnt!) Following"
            }

        }
        else {
            try! realm.write {
                //updating count in myprofile
                var count =  Int(self.myProfile.userFollwing)
                count = count! - 1
                self.myProfile.userFollwing =  "\(count!)"
                
                //updating count in FeedsData
                var cnt = Int((data.foodieFollowingCount))
                cnt = cnt! - 1
                data.foodieFollowingCount = "\(cnt!)"
                
                //updating local label
                foodieFollowLbl.text = "\((data.foodieFollowerCount)) Followers . \(cnt!) Following"
            }
        }
    }
 
    func tabViews(){
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let photosCntl:LFPhotosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFPhotosViewController") as! LFPhotosViewController
        photosCntl.title = "PHOTOS"
        photosCntl.isMyPosts = false
        
        if isFromHome{
            photosCntl.userEmail = foodiesArr[0].foodieEmail
        }else{
            photosCntl.userEmail = self.selectedFoodie.foodieEmail
        }

        controllerArray.append(photosCntl)
        
        let favoriteCntl : LFFavouriteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFFavouriteViewController") as! LFFavouriteViewController
        favoriteCntl.title = "FAVORITES"
        controllerArray.append(favoriteCntl)
        
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorColor(UIColor.appTheamColor()),
            .selectedMenuItemLabelColor(UIColor.appTheamColor()),
            .menuHeight(40),
            .scrollMenuBackgroundColor(UIColor.white),
            .menuItemWidth(self.view.frame.size.width/2-16)
        ]
        
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.restaurantView.frame.width, height: self.restaurantView.frame.height), pageMenuOptions: parameters)
        
        self.restaurantView.addSubview((self.pageMenu?.view)!)
        
        //self.view.addSubview(View_DetailsView)
        
    }

}



extension LFRestaurentDetailsViewController : UIScrollViewDelegate{
    func scrollUp(){
        print(self.restaurantScrollView.contentOffset)
        let offset : CGFloat = restaurantScrollView.contentOffset.y
        //print(offset)
        if offset >= 0 {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.restaurantScrollView.contentOffset = CGPoint(x: 0, y: 250)
            }, completion: { finished in
            })
        }
    }
    
    func scrollDown(){
        let offset : CGFloat = restaurantScrollView.contentOffset.y
        //  print(offset)
        if offset >= 250 {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.restaurantScrollView.contentOffset = CGPoint(x: 0, y: 0)
            }, completion: { finished in
            })
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        //self.Scroller_ScrollerView.contentOffset.x = 300
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //self.Scroller_ScrollerView.contentOffset = CGPoint(x: 0.0, y: 300)
        
        //  print(">>>>scrollViewDidScroll")
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //self.Scroller_ScrollerView.contentOffset = CGPoint(x: 0.0, y: 300)
        //print(">>>>scrollViewWillBeginDragging")
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
       /* if UIScreen.main.bounds.size.width == 320
        {
            
            self.restaurantScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 670)
            
        }else if UIScreen.main.bounds.size.width == 375
        {
            self.restaurantScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
            
        }else if UIScreen.main.bounds.size.width == 414
        {
            
            self.restaurantScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 870)
            
        }*/
        
        self.restaurantScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+250)

        
        // self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 845)
        
        print(">>>> scrollViewWillEndDragging ")
        //
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.restaurantScrollView.contentOffset.y = 20
        print(self.restaurantScrollView.contentInset)
    }
}

