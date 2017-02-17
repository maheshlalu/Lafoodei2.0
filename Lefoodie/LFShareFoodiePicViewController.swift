//
//  LFShareFoodiePicViewController.swift
//  Lefoodie
//
//  Created by Manishi on 1/3/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit


class LFShareFoodiePicViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var sharePhotoTableView: UITableView!
    var navController: UINavigationController!
    var postImage:UIImage!
    
    var resturantsList = [Restaurants]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postBtn.setTitleColor(UIColor.appTheamColor(), for: .normal)
        
        let nibSharePost = UINib(nibName: "LFSharePostTableViewCell", bundle: nil)
        self.sharePhotoTableView.register(nibSharePost, forCellReuseIdentifier: "LFSharePostTableViewCell")
        
        
        let nibChooseLocation = UINib(nibName: "LFChooseLocationTableViewCell", bundle: nil)
        self.sharePhotoTableView.register(nibChooseLocation, forCellReuseIdentifier: "LFChooseLocationTableViewCell")
        
        
        let nibSocialShare = UINib(nibName: "LFSocialShareTableViewCell", bundle: nil)
        self.sharePhotoTableView.register(nibSocialShare, forCellReuseIdentifier: "LFSocialShareTableViewCell")
        
        self.sharePhotoTableView.delegate = self
        self.getTheDefaultRestarent()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.sharePhotoTableView.reloadData()
    }
    
    func chooseLocation(){
        let storyboard = UIStoryboard(name: "PhotoShare", bundle: nil).instantiateViewController(withIdentifier: "LFShooseAnotherLocation")as! LFShooseAnotherLocation
        storyboard.resturantsList = self.resturantsList
        self.navigationController?.pushViewController(storyboard, animated: true)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.sharePhotoTableView.endEditing(true)
    }
    @IBAction func postBtnAction(_ sender: Any) {
        
        let indexPath : NSIndexPath = NSIndexPath(row: 0, section: 0)
        
        let cell: LFSharePostTableViewCell = self.sharePhotoTableView.cellForRow(at: indexPath as IndexPath) as! LFSharePostTableViewCell
        //print(cell.postDescTxtView)
        //print(cell.sharedPic)
        

        CXDataService.sharedInstance.showLoader(view: self.view, message: "")

        LFDataManager.sharedInstance.imageUpload(imageData: UIImageJPEGRepresentation(postImage, 0.2)!) { (Response) in
            
            if Response.allKeys.count == 0 {
                //CXDataService.sharedInstance.hideLoader()
               return
            }
        
            
            let restarurnat : Restaurants = self.resturantsList[0]
            let imgStr = Response.value(forKey: "filePath") as! String
           // print(imgStr)
            let dict:NSMutableDictionary = NSMutableDictionary()
            dict.setObject(cell.postDescTxtView.text!, forKey: "Name" as NSCopying)
            dict.setObject(imgStr, forKey: "Image" as NSCopying)
            dict.setObject(restarurnat.restaurantID, forKey: "storeId" as NSCopying)
            //dict.setObject(mobile, forKey: "Phone Number" as NSCopying
            LFDataManager.sharedInstance.sharePost(jsonDic: dict, imageData: NSData() as Data, completion: { (success) in
              //  print(success)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "POST_TO_FEED"), object: nil)
                self.dismiss(animated: true, completion: nil)
            })
            
        }
        

     
    }
    
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.navController?.popToRootViewController(animated: true)
    }
    
}

extension LFShareFoodiePicViewController: UITableViewDataSource,UITableViewDelegate{
    
    //Tableview Delegate and Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cellSharePost = tableView.dequeueReusableCell(withIdentifier: "LFSharePostTableViewCell", for: indexPath)as? LFSharePostTableViewCell
            cellSharePost?.sharedPic.image = postImage
            return cellSharePost!
            
        }else if indexPath.section == 1{
            let cellChooseLocation = tableView.dequeueReusableCell(withIdentifier: "LFChooseLocationTableViewCell", for: indexPath)as? LFChooseLocationTableViewCell
            if self.resturantsList.count != 0 {
                //print(self.resturantsList[0])
                let restarurnat : Restaurants = self.resturantsList[0]
                cellChooseLocation?.locationLbl.text = restarurnat.restaurantName
            }
            return cellChooseLocation!
            
        }else if indexPath.section == 3{
            let cellSocialShare = tableView.dequeueReusableCell(withIdentifier: "LFSocialShareTableViewCell", for: indexPath)as? LFSocialShareTableViewCell
            return cellSocialShare!
            
        }else if indexPath.section == 2 {
            let buttncell:UITableViewCell = UITableViewCell()
            buttncell.backgroundColor = UIColor.tableCellBgColor()
            let button = UIButton(type: .system) // let preferred over var here
            button.frame = CGRect(x: 0, y:10 , width: 200, height: 45)
            button.center = CGPoint(x: tableView.frame.size.width/2, y: 30)
            button.backgroundColor = UIColor.appTheamColor()
            button.setTitle("Choose Another Location", for: UIControlState.normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.cornerRadius = 3
            button.addTarget(self, action: #selector(chooseLocation), for: UIControlEvents.touchUpInside)
            buttncell.addSubview(button)
            return buttncell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 120
        }else if indexPath.section == 1{
            return 43
        }else if indexPath.section == 3{
            return 90
        }else{
           return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1{
            return 30
        }else if section == 2{
            return 0
        }
        return 0
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            let storyBoard = UIStoryboard(name: "PhotoShare", bundle: Bundle.main)
            let chooseLocation : LFShooseAnotherLocation = (storyBoard.instantiateViewController(withIdentifier: "LFShooseAnotherLocation") as? LFShooseAnotherLocation)!
            chooseLocation.resturantsList = self.resturantsList
            
            self.navController.pushViewController(chooseLocation, animated: true)
          break
        default:
            
            break
        }
    }
}


extension LFShareFoodiePicViewController{
    
    func getTheDefaultRestarent(){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "")
        LFDataManager.sharedInstance.getTheAllRestarantsFromServer { (resultArray) in
            self.resturantsList = resultArray;
            CXDataService.sharedInstance.hideLoader()
            self.sharePhotoTableView.reloadRows(at: [ NSIndexPath(row: 0, section: 1) as IndexPath], with: .fade)
           
        }
    }
}
