//
//  LFRestaurentDetailsViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import MagicalRecord

class LFRestaurentDetailsViewController: UIViewController,UIGestureRecognizerDelegate{
    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var restaurantScrollView: UIScrollView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var foodieName: UILabel!
    @IBOutlet weak var foodieFollowLbl: UILabel!
    @IBOutlet weak var foodieImgView: UIImageView!
    var selectedFoodie : SearchFoodies!
    var pageMenu : CAPSPageMenu?
    var tap: UITapGestureRecognizer?
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    
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
        let predicate = NSPredicate.init(format: "followerUserId = %@", selectedFoodie.foodieUserId)
       let  dataArray = Followers.mr_findAll(with: predicate) as NSArray
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
        let menuItem = UIBarButtonItem(image: UIImage(named: "Back-48"), style: .plain, target: self, action: #selector(LFRestaurentDetailsViewController.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
    func backBtnClicked()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func foodieDetails(){
        
        self.foodieName.text = selectedFoodie.foodieName
        
        let imgUrl = URL(string: selectedFoodie.foodieImage) as URL!
        if imgUrl != nil{
           foodieImgView.setImageWith(imgUrl, usingActivityIndicatorStyle: .gray)
            
        }else{
            foodieImgView.image = UIImage(named: "placeHolder")
        }
        let following = selectedFoodie.foodieFollowingCount
        let follower = selectedFoodie.foodieFollowerCount
        foodieFollowLbl.text = "\(follower) Followers . \(following) Following"
        
    }
    
    @IBAction func settingBtnAction(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundlvarnil).instantiateViewController(withIdentifier: "LFItemDetailViewController")as? LFItemDetailViewController
        //        self.navigationController?.pushViewController(storyboard!, animated: true)
        
    }
    
    @IBAction func followBtnAction(_ sender: AnyObject) {
        
        if followBtn.titleLabel?.text == "Follow" {
            followBtn.setTitle("UnFollow", for: .normal)
            LFDataManager.sharedInstance.followTheUser(foodieDetails: selectedFoodie)
        }
        else {
            followBtn.setTitle("Follow", for: .normal)
            LFDataManager.sharedInstance.unFollowTheUser(foodieDetails: selectedFoodie)
        }
    }
 
    func tabViews(){
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1:LFPhotosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFPhotosViewController") as! LFPhotosViewController
        controller1.title = "FOODIE PHOTOS"
        controllerArray.append(controller1)
        
        let controller2 : LFFavouriteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFFavouriteViewController") as! LFFavouriteViewController
        controller2.title = "ACCOUNT PHOTOS"
        controllerArray.append(controller2)
        
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

