
//
//  LFUserProfileViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 03/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import RealmSwift
class LFUserProfileViewController: UIViewController {
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userFirstNameLbl: UILabel!
    @IBOutlet weak var userLastNameLbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var followingCountLbl: UILabel!
    
    @IBOutlet weak var Scroller_ScrollerView: UIScrollView!
    @IBOutlet weak var View_DetailsView: UIView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userBannerImbView: UIImageView!
    var pageMenu : CAPSPageMenu?
    var myProfile : LFMyProfile!
    var screenVal = String()
    
    override func viewDidLoad() {
        self.tabViews()
        self.notificationRegistration()
        self.setNavigationProperty()
        screenVal = "screenVal"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.populatedData()
  }
    
    func setNavigationProperty(){
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)

    }
    
    func notificationRegistration(){
        NotificationCenter.default.addObserver(self, selector: #selector(LFUserProfileViewController.scrollUp), name:NSNotification.Name(rawValue: "scrollUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LFUserProfileViewController.scrollDown), name:NSNotification.Name(rawValue: "ScrollDown"), object: nil)
    }
    
    func populatedData(){
        let realm = try! Realm()
        self.myProfile = realm.objects(LFMyProfile.self).first
    
        self.userPic.setImageWith(NSURL(string: self.myProfile.userPic) as URL!, usingActivityIndicatorStyle: .white)
        self.userBannerImbView.setImageWith(NSURL(string: self.myProfile.userBannerPic) as URL!, usingActivityIndicatorStyle: .white)
        self.userFirstNameLbl.text = self.myProfile.userFirstName
        self.userLastNameLbl.text = self.myProfile.userLastName
        self.followingCountLbl.text = "\(self.myProfile.userFollwing) Following"
        
        self.followingCountLbl.isUserInteractionEnabled = true
        let gestureRecognizerFollowing = UITapGestureRecognizer(target: self, action: #selector(followingList))
        self.followingCountLbl.addGestureRecognizer(gestureRecognizerFollowing)
        
        self.followersCountLbl.text = "\(self.myProfile.userFollowers) Follwers"
        
        self.followersCountLbl.isUserInteractionEnabled = true
        let gestureRecognizerFollowers = UITapGestureRecognizer(target: self, action: #selector(followerList))
        self.followersCountLbl.addGestureRecognizer(gestureRecognizerFollowers)
        
    }

    @IBAction func settingBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFOptionsViewController")as! LFOptionsViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    func followingList(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFUserFollowerAndFollowingViewController")as? LFUserFollowerAndFollowingViewController
        storyboard?.navigationController?.isNavigationBarHidden = false
        storyboard?.isFollower = false
        UIApplication.shared.keyWindow?.rootViewController?.present(storyboard!, animated: true, completion: nil)
    }
    
    func followerList(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFUserFollowerAndFollowingViewController")as? LFUserFollowerAndFollowingViewController
        storyboard?.navigationController?.isNavigationBarHidden = false
        storyboard?.isFollower = true
        UIApplication.shared.keyWindow?.rootViewController?.present(storyboard!, animated: true, completion: nil)
    }
    
    // Do any additional setup after loading the view.
    
    func tabViews(){
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let photosControl:LFPhotosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFPhotosViewController") as! LFPhotosViewController
        
        photosControl.isMyPosts = true
        photosControl.userEmail = CXAppConfig.sharedInstance.getEmailID()
        
        
        let favoriteContl : LFFavouriteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFFavouriteViewController") as! LFFavouriteViewController
        
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorColor(UIColor.appTheamColor()),
            .selectedMenuItemLabelColor(UIColor.appTheamColor()),
            .menuHeight(40),
            .scrollMenuBackgroundColor(UIColor.white),
            .menuItemWidth(self.view.frame.size.width/2-16)
        ]
        
        if screenVal == "User" {
            photosControl.title = "PHOTOS"
            favoriteContl.title = "FAVORITES"
        }
        else {
            photosControl.title = "FOODIE PHOTOS"
            favoriteContl.title = "ACCOUNT PHOTOS"
        }
        controllerArray.append(photosControl)
        controllerArray.append(favoriteContl)
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.uiView.frame.width, height: self.uiView.frame.height), pageMenuOptions: parameters)
        
        self.uiView.addSubview((self.pageMenu?.view)!)

        //self.view.addSubview(View_DetailsView)
        
    }
    
}





extension LFUserProfileViewController:UIScrollViewDelegate{
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        //self.Scroller_ScrollerView.contentOffset.x = 300
        return true
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView){
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //print(">>>>scrollViewWillBeginDragging")
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if UIScreen.main.bounds.size.width == 320
        {
            
            self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
            
        }else if UIScreen.main.bounds.size.width == 375
        {
            self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
            
        }else if UIScreen.main.bounds.size.width == 414
        {
            
            self.Scroller_ScrollerView.contentSize = CGSize(width: self.view.frame.size.width, height: 870)
            
        }
        //print(">>>> scrollViewWillEndDragging ")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //self.Scroller_ScrollerView.contentOffset.y = 200
        //print(self.Scroller_ScrollerView.contentInset)
        
    }
    func scrollUp(){
        print(self.Scroller_ScrollerView.contentOffset)
        let offset : CGFloat = Scroller_ScrollerView.contentOffset.y
        //print(offset)
        if offset >= 0 {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.Scroller_ScrollerView.contentOffset = CGPoint(x: 0, y: 300)
            }, completion: { finished in
            })
        }
        
        
    }
    
    func scrollDown(){
        let offset : CGFloat = Scroller_ScrollerView.contentOffset.y
        //  print(offset)
        if offset >= 290 {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.Scroller_ScrollerView.contentOffset = CGPoint(x: 0, y: 0)
            }, completion: { finished in
            })
        }
        
    }
}


extension LFUserProfileViewController {
    
    
    func getTheUserPostedPhots(email:String,isMyposts:Bool){
        
//        LFDataManager.sharedInstance.getUserPosts(userEmail: email, myPosts: isMyposts, pageNumber: "", pageSize: "") { (responce) in
//            
//            print(responce)
//        }
        // LFDataManager.sharedInstance.getUserPosts(userEmail: "", myPosts: true, pageNumber: "0", pageS
        
        LFDataManager.sharedInstance.getUserPosts(userEmail: "", myPosts: isMyposts, pageNumber: "", pageSize: "") { (isSaved, feedsResults) in
            
        }
        
    }
    
}
