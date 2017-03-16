//
//  LFShareFoodiePicViewController.swift
//  Lefoodie
//
//  Created by Manishi on 1/3/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import RealmSwift
import TMTumblrSDK
import FBSDKCoreKit
import FBSDKShareKit
import TwitterKit
import OAuthSwift
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
    var hashTagsList : Results<LFHashTags>!
    var userNamesList : Results<LFUserNames>!
    var descTextView = UITextView()
    var tempArray = NSArray()
    
    var atTheRateArray = NSMutableArray()
    var hashArray = NSMutableArray()

    var isHashGenerated = Bool()
    
    var isFb:Bool = false
    var isTwitter:Bool = false
    var isTumbler:Bool = false
    var isFlickr:Bool = false
    
    var isHash = Bool()

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
            if isHash {
                if hashTagsList == nil {
                    return 0
                }
                return hashTagsList.count
            }
            else {
                if userNamesList == nil {
                    return 0
                }
                return userNamesList.count
            }
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
                
                cellSocialShare?.fbBtn.addTarget(self, action: #selector(fbBtnAction), for: .touchUpInside)
                cellSocialShare?.TwittrBtn.addTarget(self, action: #selector(twitterBtnAction), for: .touchUpInside)
                cellSocialShare?.tumblrBtn.addTarget(self, action: #selector(tumblrBtnAction), for: .touchUpInside)
                cellSocialShare?.flickrBtn.addTarget(self, action: #selector(flickrBtnAction), for: .touchUpInside)
                
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
            if isHash {
            let hashTag = hashTagsList[indexPath.row]
            cell.textLabel?.text = "#\(hashTag.name)"
            }
            else {
                let user = userNamesList[indexPath.row]
                
                let imgUrl = URL(string: user.userImagePath) as URL!
                let userImageView = UIImageView.init(frame: CGRect(x: 10, y: 7, width: 30, height: 30))
                if imgUrl != nil{
                    userImageView.setImageWith(imgUrl, usingActivityIndicatorStyle: .gray)
                    
                }else{
                    userImageView.image = UIImage(named: "placeHolder")
                }
                
//                userImageView.sd_setImage(with: NSURL.init(string: user.userImagePath) as URL!, placeholderImage: nil)
                userImageView.layer.cornerRadius = 15
                userImageView.clipsToBounds = true
                cell.contentView.addSubview(userImageView)
                
                let userNameLabel = UILabel.init(frame: CGRect(x: 50, y: 11, width: 150, height: 20))
                userNameLabel.font = UIFont.systemFont(ofSize: 14)
                userNameLabel.text = "@\(user.uniqueUsername)"
                cell.contentView.addSubview(userNameLabel)
//                cell.imageView?.sd_setImage(with: NSURL.init(string: user.userImagePath) as URL!, placeholderImage: nil)
//                cell.imageView?.layer.cornerRadius = 20
//                cell.imageView?.clipsToBounds = true
//                cell.textLabel?.text = "@\(user.uniqueUsername)"
            }
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
            
            if isHash {
                let hashTag = hashTagsList[indexPath.row]
                descTextView.text = "\(obj) \(char!)\(hashTag.name)"
            }
            else {
                let userName = userNamesList[indexPath.row]
                descTextView.text = "\(obj) \(char!)\(userName.uniqueUsername)"
            }
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
            dict.setObject(String.construcThetagString(array: self.hashArray,isAddTag:true), forKey: "Hashtags" as NSCopying)
            
            LFDataManager.sharedInstance.sharePost(jsonDic: dict, imageData: NSData() as Data, hastTagString:String.construcThetagString(array: self.hashArray,isAddTag:false),completion: { (success) in
                //  print(success)
                self.ShareOnSocialMedia()
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
                    if text == "#" {
                        isHash = true
                        self.hashTagsList = nil
                    }
                    else
                    {
                        isHash = false
                        self.userNamesList = nil
                    }
                    popUpTableView.reloadData()
                    popUpTableView.backgroundColor = UIColor.black
                    popUpTableView.alpha = 0.5
                }
                else
                {
                    var str = textView.text.components(separatedBy: " ").last?.appending(text)
                    // # search
                    if str?[(str?.startIndex)!] == "#" {
                        isHash = true
                    str = str?.replace(target: "#", withString: "")
                    let predicate = NSPredicate.init(format: "name CONTAINS[c] %@",str!)
                    CXDataService.sharedInstance.showLoader(view: self.view, message: "")
                    let relamInstance = try! Realm()
                    self.hashTagsList = relamInstance.objects(LFHashTags.self).filter(predicate)
                        if self.hashTagsList.count == 0 {
                            LFDataManager.sharedInstance.getHashTagDataFromServerUsingKeyword(keyword: str!, completion: { (response) in
                                DispatchQueue.main.async {
                                    self.popUpTableView.reloadData()
                                    self.popUpTableView.backgroundColor = UIColor.white
                                    self.popUpTableView.alpha = 1
                                    CXDataService.sharedInstance.hideLoader()
                                }
                            })
                        }
                        else {
                            popUpTableView.reloadData()
                            popUpTableView.backgroundColor = UIColor.white
                            popUpTableView.alpha = 1
                            CXDataService.sharedInstance.hideLoader()
                        }
                    
                    }
                    // @ search
                    else {
                        isHash = false
                        str = str?.replace(target: "@", withString: "")
                        let predicate = NSPredicate.init(format: "uniqueUsername CONTAINS[c] %@",str!)
                        CXDataService.sharedInstance.showLoader(view: self.view, message: "")
                        let relamInstance = try! Realm()
                        self.userNamesList = relamInstance.objects(LFUserNames.self).filter(predicate)
                        if self.userNamesList.count == 0 {
                            LFDataManager.sharedInstance.getUserNameDataFromServerUsingKeyword(keyword: str!, completion: { (response) in
                                DispatchQueue.main.async {
                                    self.popUpTableView.reloadData()
                                    self.popUpTableView.backgroundColor = UIColor.white
                                    self.popUpTableView.alpha = 1
                                    CXDataService.sharedInstance.hideLoader()
                                }
                            })
                        }
                        else {
                            popUpTableView.reloadData()
                            popUpTableView.backgroundColor = UIColor.white
                            popUpTableView.alpha = 1
                            CXDataService.sharedInstance.hideLoader()
                        }
                    }
                }

            }
            // If no Hash key is generated
            else {
                if (text == "@" || text == "#") && textView.text.characters.count == 0
                {
                    if text == "@"
                {
                        isHash = false
                    }
                    else if text == "#"
                    {
                        isHash = true
                    }
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
            let str1 = str.components(separatedBy: " ").last
//            let str1 = arr.last! as String
            let arr1 = str1?.components(separatedBy: "@")
            let arr2 = str1?.components(separatedBy: "#")
            if arr1?[0] == "" && arr1?.count == 2 && !(arr1?[1].contains("#"))! {
                isHash = false
                isHashGenerated = true
                var str = textView.text.components(separatedBy: " ").last
                if (str?.characters.count)! > 2 {
                    if str?[(str?.startIndex)!] == "@" {
                        str = str?.replace(target: "@", withString: "")
                        let endIndex = str?.index((str?.endIndex)!, offsetBy: -1)
                        let truncated = str?.substring(to: endIndex!)
                        let predicate = NSPredicate.init(format: "uniqueUsername CONTAINS[c] %@",truncated!)
                        let relamInstance = try! Realm()
                        self.userNamesList = relamInstance.objects(LFUserNames.self).filter(predicate)
                        popUpTableView.reloadData()
                        popUpTableView.backgroundColor = UIColor.white
                        popUpTableView.alpha = 1
                    }
                }
                else {
                    //while removing text if user removes last #
                    if str1 == "@"{
                        isHashGenerated = false
                    }
                    self.userNamesList = nil
                    popUpTableView.reloadData()
                    popUpTableView.backgroundColor = UIColor.black
                    popUpTableView.alpha = 0.5
                }
            }
            else if arr2?[0] == "" && arr2?.count == 2 && !(arr2?[1].contains("@"))!{
               isHash = true
                isHashGenerated = true
                var str = textView.text.components(separatedBy: " ").last
                if (str?.characters.count)! > 2 {
                    if str?[(str?.startIndex)!] == "#" {
                        str = str?.replace(target: "#", withString: "")
                        let endIndex = str?.index((str?.endIndex)!, offsetBy: -1)
                        let truncated = str?.substring(to: endIndex!)
                        let predicate = NSPredicate.init(format: "name CONTAINS[c] %@",truncated!)
                        let relamInstance = try! Realm()
                        self.hashTagsList = relamInstance.objects(LFHashTags.self).filter(predicate)
                        popUpTableView.reloadData()
                        popUpTableView.backgroundColor = UIColor.white
                        popUpTableView.alpha = 1
                    }
                }
                else {
                    //while removing text if user removes last #
                    if str1 == "#"{
                       isHashGenerated = false
                    }
                    self.hashTagsList = nil
                    popUpTableView.reloadData()
                    popUpTableView.backgroundColor = UIColor.black
                    popUpTableView.alpha = 0.5
                }
            }
            else {
                self.hashTagsList = nil
                self.userNamesList = nil
                tempArray = NSArray()
                popUpTableView.reloadData()
                popUpTableView.backgroundColor = UIColor.black
                popUpTableView.alpha = 0.5
            }
        }
        CXDataService.sharedInstance.hideLoader()
            return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        atTheRateArray = NSMutableArray()
        hashArray = NSMutableArray()
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

//MARK: Sahre post on Social Media
extension LFShareFoodiePicViewController{
    func fbBtnAction(sender:UIButton){
        if sender.isSelected{
            sender.isSelected = false
            isFb = false
            print("not selected")
        }else{
            isFb = true
            sender.isSelected = true
            print("selected")
        }
        
    }
    
    func twitterBtnAction(sender:UIButton){
        if sender.isSelected{
            sender.isSelected = false
            isTwitter = false
            print("not selected")
        }else{
            isTwitter = true
            sender.isSelected = true
            print("selected")
        }
    }
    
    func tumblrBtnAction(sender:UIButton){
        if sender.isSelected{
            sender.isSelected = false
            isTumbler = false
            print("not selected")
        }else{
            isTumbler = true
            sender.isSelected = true
            print("selected")
        }
    }
    
    func flickrBtnAction(sender:UIButton){
        if sender.isSelected{
            sender.isSelected = false
            isFlickr = false
            print("not selected")
        }else{
            isFlickr = true
            sender.isSelected = true
            print("selected")
        }
        
    }
    
    
    func ShareOnSocialMedia(){
        
        if self.isFb{
            print("fb alive")
            
            var params : NSDictionary = NSDictionary()
//            params = ["message" : dict.value(forKey: "Name")!,
//                      "image": Response.value(forKey: "filePath") as! String]
            let request : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/feed", parameters: params as [NSObject : AnyObject], httpMethod: "POST")
            request.start(completionHandler: { (connection, result, error) -> Void in
                
            })
            
            /*        let oauthswift = OAuth2Swift(
             consumerKey:    serviceParameters["consumerKey"]!,
             consumerSecret: serviceParameters["consumerSecret"]!,
             authorizeUrl:   "https://www.facebook.com/dialog/oauth",
             accessTokenUrl: "https://graph.facebook.com/oauth/access_token",
             responseType:   "code"
             )
             
             self.oauthswift = oauthswift
             oauthswift.authorizeURLHandler = getURLHandler()
             let state = generateState(withLength: 20)
             let _ = oauthswift.authorize(
             withCallbackURL: URL(string: "https://oauthswift.herokuapp.com/callback/facebook")!, scope: "public_profile", state: state,
             success: { credential, response, parameters in
             self.showTokenAlert(name: serviceParameters["name"], credential: credential)
             self.testFacebook(oauthswift)
             }, failure: { error in
             print(error.localizedDescription, terminator: "")
             }
             )*/
            
            //let contentTitle = dict.value(forKey: "Name")
            //let contentImageUrl = Response.value(forKey: "filePath") as! String
            
            //let content: FBSDKSharingContent!
            //content.contentURL = NSURL(string: contentUrl) as URL!
            //content.contentURL
            //content.contentTitle = contentTitle as! String!
            // content.contentDescription = contentDescription
            //content.imageURL = NSURL(string:contentImageUrl) as URL!
            //FBSDKShareDialog.show(from: self, with: content, delegate: nil)
            
            //                let content:FBSDKShareLinkContent = FBSDKShareLinkContent()
            //                content.contentTitle = contentTitle as! String!
            //                content.imageURL = NSURL(string:contentImageUrl) as URL!
            //                let dialog = FBSDKShareDialog()
            //                dialog.fromViewController = self
            //                dialog.shareContent = content
            //                dialog.mode = FBSDKShareDialogMode.shareSheet
            //                dialog.show()
            
            //                LFDataManager.sharedInstance.sharePost(jsonDic: dict, imageData: NSData() as Data, completion: { (success) in
            //                    //  print(success)
            //                    .
            //                    NotificationCenter.default.post(name: Notification.Name(rawValue: "POST_TO_FEED"), object: nil)
            //                    self.dismiss(animated: true, completion: nil)
            //                })
        }
        
        if self.isTwitter{
            print("twitter alive")
            
            let oauthswift = OAuth1Swift(
                consumerKey:    "WLjk9lBRRsRpAhxIODwqX1XX8",
                consumerSecret: "ZpTYeWo3gSf0nJACkYILA8hvyLtND8T1QmQJGwibjjERd67uqc",
                requestTokenUrl: "https://api.twitter.com/oauth/request_token",
                authorizeUrl:    "https://api.twitter.com/oauth/authorize",
                accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
            )
            let handle = oauthswift.authorize(
                withCallbackURL: URL(string: "oauth-swift://oauth-callback/twitter")!,
                success: { credential, response, parameters in
                    print(credential.oauthToken)
                    print(credential.oauthTokenSecret)
                    print(parameters["user_id"]!)
                    
                    let composer = TWTRComposer()
                    
                    composer.setText("just setting up my Fabric")
                    composer.setImage(UIImage(named: "fabric"))
                    
                    // Called from a UIViewController
                    composer.show(from: self) { result in
                        if (result == TWTRComposerResult.cancelled) {
                            print("Tweet composition cancelled")
                        }
                        else {
                            print("Sending tweet!")
                        }
                    }
            },
                failure: { error in
                    print(error.localizedDescription)
            }
            )
            
        }
        
        if self.isTumbler{
            print("tumbler alive")
            //
            //                TMAPIClient.sharedInstance().oAuthConsumerKey = ""
            //                TMAPIClient.sharedInstance().oAuthConsumerSecret = ""
            //                TMAPIClient.sharedInstance().oAuthToken = ""
            //                TMAPIClient.sharedInstance().oAuthTokenSecret = ""
            //
            //
            //                // TODO: Fill in your blog name
            //                TMAPIClient.sharedInstance().post("", type:imgStr, parameters: ["caption": "Caption"], callback: {( response: Any,  error: Error?) -> Void in
            //                    if error != nil {
            //                        print("Error posting to Tumblr")
            //                    }
            //                    else {
            //                        print("Posted to Tumblr")
            //                    }
            //                })
        }
        
        if self.isFlickr{
            print("flickr alive")
            
        }
    }
    
}



