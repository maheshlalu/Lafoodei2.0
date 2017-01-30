//
//  LFHomeViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 30/12/16.
//  Copyright © 2016 NOVO. All rights reserved.
//

import UIKit
import SDWebImage

class LFHomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var homeTableView: UITableView!
    var Arr_Main = NSMutableArray()
    
    override func viewDidLoad() {
       // self.serviceAPICall(PageNumber: "0", PageSize: "10")
        super.viewDidLoad()
        self.registerCells()
        self.selectedTabBar()
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        
    }
    

    
    func registerCells(){
        self.homeTableView.register(UINib(nibName: "LFHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHeaderTableViewCell")
        self.homeTableView.register(UINib(nibName: "LFHomeCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHomeCenterTableViewCell")
        self.homeTableView.register(UINib(nibName: "LFHomeFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "LFHomeFooterTableViewCell")
    }
    
    func selectedTabBar(){
        
        let tabBar = self.tabBarController?.tabBar
        tabBar?.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: (tabBar?.frame.width)!/CGFloat((tabBar?.items!.count)!), height: (tabBar?.frame.height)!), lineWidth: 3.0)
    }
    
    
    //MARK: calling home data from service
    func serviceAPICall(PageNumber: NSString, PageSize: NSString)
    {
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        
        let Url_base = "http://storeongo.com:8081/Services/getMasters?type=allMalls&pageNumber=" + (PageNumber as String) + "&pageSize=" + (PageSize as String)
        let urlStr = NSString.init(string: Url_base)
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(urlStr as String, parameters: ["":"" as AnyObject]) { (responceDic
            ) in
            print("Get Data is \(responceDic)")
            let Str_Email = responceDic.value(forKey: "orgs") as! NSArray
            print("Email id is\(Str_Email)")
            self.Arr_Main = Str_Email.mutableCopy() as! NSMutableArray
            print("Total Arr \(self.Arr_Main)")
            CXDataService.sharedInstance.hideLoader()
            self.homeTableView.reloadData()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5 //self.Arr_Main.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       return 3
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell = UITableViewCell()
        //let Dict_Detail = self.Arr_Main.object(at: indexPath.section) as AnyObject
        if indexPath.row == 0 {
            
            cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHeaderTableViewCell", for: indexPath)as? LFHeaderTableViewCell)!
            
         /* let cell1  = (tableView.dequeueReusableCell(withIdentifier: "LFHeaderTableViewCell", for: indexPath)as? LFHeaderTableViewCell)!
            
            cell1.lbl_Title.text = (Dict_Detail.value(forKey: "category") as AnyObject) as? String*/
            
            
        }else if indexPath.row == 1 {
           
            cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHomeCenterTableViewCell", for: indexPath)as? LFHomeCenterTableViewCell)!
            
            /*let cell_2  = (tableView.dequeueReusableCell(withIdentifier: "LFHomeCenterTableViewCell", for: indexPath)as? LFHomeCenterTableViewCell)!
            
            let imgurl_Url = CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: Dict_Detail as! NSDictionary, sourceKey: "logo")
            let url_Url:NSURL = NSURL(string: imgurl_Url as String)!
            cell_2.ImgView_Logo.setImageWith(url_Url as URL!, usingActivityIndicatorStyle: .white)*/
            
        }else if indexPath.row == 2 {
              cell  = (tableView.dequeueReusableCell(withIdentifier: "LFHomeFooterTableViewCell", for: indexPath)as? LFHomeFooterTableViewCell)!
            
        }

        return cell
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
      //  let viewcontroller:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFFoodDetailViewController")as UIViewController
        //self.present(viewcontroller, animated: true, completion: nil)
        
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
            print("Home selected")
        //show popular view
        case 1:
            
            print("near selected")
            
            
            
            UIView.transition(with: self.homeTableView, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromRight, animations: nil, completion: nil)
            
        //show history view
        default:
            break;
        }
        
    }
    

   

}
