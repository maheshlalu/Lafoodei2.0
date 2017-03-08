//
//  LFShareFoodiePicViewController.swift
//  Lefoodie
//
//  Created by Manishi on 1/3/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFShareFoodiePicViewController: UIViewController,UIScrollViewDelegate{
    
 
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var sharePhotoTableView: UITableView!
    var navController: UINavigationController!
    var postImage:UIImage!
    var resturantsList = [Restaurants]()
    var restaurantsLocationsList = [RestaurantsLocation]()
    var popUpTableView : UITableView! = nil
    var topLabel : UILabel! = nil
    var topOkBtn : UIButton! = nil
    var tempArray = NSArray()
    var descTextView = UITextView()

    var isHashGenerated = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        isHashGenerated = false
        
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
        self.sharePhotoTableView.reloadRows(at: [ NSIndexPath(row: 0, section: 1) as IndexPath], with: .fade)
    }
    
//    func restaurantDetails(resturantsList: [Restaurants]) {
//        self.resturantsList = resturantsList
//        let restarurnat : Restaurants = resturantsList[0]
//        self.getTheRLocation(locationId: restarurnat.restaurantID)
//        self.sharePhotoTableView.reloadRows(at: [ NSIndexPath(row: 0, section: 1) as IndexPath], with: .fade)
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.sharePhotoTableView.endEditing(true)
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.navController?.popToRootViewController(animated: true)
    }
    
    
}

extension LFShareFoodiePicViewController: UITableViewDataSource,UITableViewDelegate {
    
    //Tableview Delegate and Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == sharePhotoTableView {
            return 1
        }
        else {
            return tempArray.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == sharePhotoTableView {
            return 4
        }
        else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == sharePhotoTableView {
            if indexPath.section == 0{
                let cellSharePost = tableView.dequeueReusableCell(withIdentifier: "LFSharePostTableViewCell", for: indexPath)as? LFSharePostTableViewCell
                cellSharePost?.sharedPic.image = postImage
                cellSharePost?.postDescTxtView.delegate = self
                descTextView = (cellSharePost?.postDescTxtView)!
                return cellSharePost!
                
            }else if indexPath.section == 1{
                let cellChooseLocation = tableView.dequeueReusableCell(withIdentifier: "LFChooseLocationTableViewCell", for: indexPath)as? LFChooseLocationTableViewCell
                if self.resturantsList.count != 0 && self.restaurantsLocationsList.count != 0 {
                    
                    let restarurnat : Restaurants = self.resturantsList[0]
                    let reataurantLocation = self.restaurantsLocationsList[0]
                    cellChooseLocation?.locationLbl.text = restarurnat.restaurantName
                    cellChooseLocation?.RLocationLbl.text = reataurantLocation.RLocationAddress
                    
                    let userRestaurantGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseLocation))
                    cellChooseLocation?.locationLbl.addGestureRecognizer(userRestaurantGestureRecognizer)
                    cellChooseLocation?.RLocationLbl.addGestureRecognizer(userRestaurantGestureRecognizer)
                    cellChooseLocation?.RLocationLbl.tag = indexPath.section
                    cellChooseLocation?.locationLbl.tag = indexPath.section
                    
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
        else {
            let cell = UITableViewCell()
            cell.textLabel?.text = tempArray[indexPath.row] as! String
            return cell

        }
        
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == sharePhotoTableView {
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
        else {
            return 44
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
        if  tableView != sharePhotoTableView {
            let str = descTextView.text as NSString
            var arr  = str.components(separatedBy: " ")
            let last = arr.last
            let char = last?[(last?.startIndex)!]
            arr.removeLast()
            let arr2 = arr as NSArray
            let obj = arr2.componentsJoined(by: " ")
            descTextView.text = "\(obj) \(char!)\(tempArray[indexPath.row])"
        }
    }
    
    func chooseLocation(){
        let storyboard = UIStoryboard(name: "PhotoShare", bundle: nil).instantiateViewController(withIdentifier: "LFShooseAnotherLocation")as! LFShooseAnotherLocation
        storyboard.resturantsList = self.resturantsList
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    func chooseRLocation(){
        let restarurnat : Restaurants = self.resturantsList[0]
        self.getTheRLocation(locationId: restarurnat.restaurantID)
        
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
    
}

extension LFShareFoodiePicViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(text)
        print(textView.text)
        
        //while entering text
        if text != ""
        {
            // if Hash Key is aleady created
            if isHashGenerated {
                
                if text == "@" || text == "#" || text == " "
                {
                    isHashGenerated = false
                    tempArray = NSArray()
                    popUpTableView.reloadData()
                    popUpTableView.backgroundColor = UIColor.black
                    popUpTableView.alpha = 0.5
                }
                else
                {
                    tempArray = ["Hi","Hello","H r u"]
                    popUpTableView.reloadData()
                    popUpTableView.backgroundColor = UIColor.white
                    popUpTableView.alpha = 1
                }

            }
            // If no Hash key is generated
            else {
                if (text == "@" || text == "#") && textView.text.characters.count == 0
                {
                    isHashGenerated = true
                }
                else if (text == "@" || text == "#") && textView.text.characters.last == " "
                {
                    isHashGenerated = true
                    
                }
                tempArray = NSArray()
                popUpTableView.reloadData()
                popUpTableView.backgroundColor = UIColor.black
                popUpTableView.alpha = 0.5
            }
        }
        //while removing text
        else {
            if textView.text.characters.count == 1
            {
                isHashGenerated = false
            }
            let str = textView.text as String
            let arr = str.components(separatedBy: " ")
            let str1 = arr.last! as String
            let arr1 = str1.components(separatedBy: "@")
            let arr2 = str1.components(separatedBy: "#")
            if arr1[0] == "" && arr1.count == 2 && !arr1[1].contains("#") {
                tempArray = ["Hi","Hello","H r u"]
                popUpTableView.reloadData()
                popUpTableView.backgroundColor = UIColor.white
                popUpTableView.alpha = 1
            }
            else if arr2[0] == "" && arr2.count == 2 && !arr2[1].contains("@"){
                tempArray = ["Hi","Hello","H r u"]
                popUpTableView.reloadData()
                popUpTableView.backgroundColor = UIColor.white
                popUpTableView.alpha = 1
            }
            else {
                tempArray = NSArray()
                popUpTableView.reloadData()
                popUpTableView.backgroundColor = UIColor.black
                popUpTableView.alpha = 0.5
            }
        }
            return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        popUpTableView = UITableView.init(frame: CGRect(x: 0, y: 180, width: self.view.frame.size.width, height: self.view.frame.size.height - 180))
        popUpTableView.delegate = self
        popUpTableView.dataSource = self
        popUpTableView.backgroundColor = UIColor.black
        popUpTableView.alpha = 0.5
        self.view.addSubview(popUpTableView)
        
        topLabel = UILabel.init(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 46))
        topLabel.textAlignment = NSTextAlignment.center
        topLabel.text = "Caption"
        topLabel.backgroundColor = UIColor.gray
        self.view.addSubview(topLabel)
        
        topOkBtn = UIButton.init(frame: CGRect(x: self.view.frame.size.width - 60, y: 28, width: 60, height: 30))
        topOkBtn.setTitle("Ok", for: .normal)
        topOkBtn.addTarget(self, action: #selector(okBtnAction), for: .touchUpInside)
       self.view.addSubview(topOkBtn)
    }
    func okBtnAction()
    {
        topLabel.removeFromSuperview()
        topOkBtn.removeFromSuperview()
        popUpTableView.removeFromSuperview()
        descTextView.resignFirstResponder()
        let atTheRateArray = NSMutableArray()
        let hashArray = NSMutableArray()
        let str = descTextView.text
        let arr = str?.components(separatedBy: " ")
        for obj in arr! {
            let arr1 = obj.components(separatedBy: "@")
            let arr2 = obj.components(separatedBy: "#")
            if arr1[0] == "" && arr1.count == 2 && arr1[1] != "" && !arr1[1].contains("#") {
                atTheRateArray.add(obj)
            }
            else if arr2[0] == "" && arr2.count == 2 && arr2[1] != "" && !arr2[1].contains("@"){
                hashArray.add(obj)
            }
        }
        print("@ Array is: \(atTheRateArray)")
        print("# Array is: \(hashArray)")
    }
}


extension LFShareFoodiePicViewController{
    
    func getTheDefaultRestarent(){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "")
        LFDataManager.sharedInstance.getTheAllRestarantsFromServer { (resultArray) in
            self.resturantsList = resultArray;
            
            let restarurnat : Restaurants = self.resturantsList[0]
            self.getTheRLocation(locationId: restarurnat.restaurantID)
            
            CXDataService.sharedInstance.hideLoader()
            self.sharePhotoTableView.reloadRows(at: [ NSIndexPath(row: 0, section: 1) as IndexPath], with: .fade)
           
        }
    }
    
    func getTheRLocation(locationId:String){
        LFDataManager.sharedInstance.getTheRestaurantLocationsFromServer(restaurantId:locationId) { (resultArray) in
            self.restaurantsLocationsList = resultArray
            self.sharePhotoTableView.reloadRows(at: [ NSIndexPath(row: 0, section: 1) as IndexPath], with: .fade)
        }
    }
}
