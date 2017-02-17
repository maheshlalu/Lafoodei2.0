
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
class LFHomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var segmentController: UISegmentedControl!

    @IBOutlet weak var homeTableView: UITableView!
    var Arr_Main = NSMutableArray()
    var jobsArray = NSArray()
    var feedsArray = [LFFeedsData]()
    var refreshControl : UIRefreshControl!

    override func viewDidLoad() {
        
        self.serviceAPICall(PageNumber: "1", PageSize: "10")
        super.viewDidLoad()
        self.registerCells()
        self.selectedTabBar()
        self.setSegmentProperties()
        self.addThePullTorefresh()
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
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.homeTableView.addSubview(self.refreshControl)
        //self.homeTableView.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
    }
    
     func refresh(sender:UIRefreshControl) {
        self.serviceAPICall(PageNumber: "1", PageSize: "10")

    }
   
    func registerCells(){
        self.homeTableView.register(UINib(nibName: "LFHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHeaderTableViewCell")
        self.homeTableView.register(UINib(nibName: "LFHomeCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHomeCenterTableViewCell")
        self.homeTableView.register(UINib(nibName: "LFHomeFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHomeFooterTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationProperties()
     
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
        LFDataManager.sharedInstance.getTheHomeFeed(pageNumber: "", pageSize: "", userEmail: CXAppConfig.sharedInstance.getEmailID()) { (resultFeeds) in
            self.feedsArray = resultFeeds
            self.homeTableView.reloadData()
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
            cell.selectionStyle = .none
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


//MARK: TableView Pagination






