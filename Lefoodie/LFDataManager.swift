
//
//  LFDataManager.swift
//  Lefoodie
//
//  Created by apple on 06/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire
import SwiftyJSON
import MagicalRecord
import RealmSwift

private var sharedManager:LFDataManager! = LFDataManager()

class LFDataManager: NSObject {

    var tabManager : LFTabHomeController!
    class var sharedInstance : LFDataManager {
        return sharedManager
    }
    
    func dataManager()->LFTabHomeController{
        
        return tabManager
    }
    
}

//MARK: Share Post
extension LFDataManager{
    /*
     dt=CAMPAIGNS&type=User Posts&category=Products&userId=6&json={"list":[{"Name":"Good product","Image":"http:\/\/35.160.251.153:8085\/coin\/files\/null\/android\/uploads\/2_profilePic.jpg","storeId":"4"}]}&consumerEmail="nadapananagababu@gmail.com"
     */
    
    func sharePost(jsonDic:NSDictionary,imageData:Data,completion:@escaping (_ responseDict:Bool) -> Void){
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"User Posts" as AnyObject,"json":String.genarateJsonString(dataDic: jsonDic) as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Products" as AnyObject,"userId":"6" as AnyObject,"consumerEmail": CXAppConfig.sharedInstance.getEmailID() as AnyObject]) { (responseDict) in
            let resultDic = JSON(responseDict)
            let mallIIDJson  = resultDic["myHashMap"].dictionary! as [String:JSON]
            LFFireBaseDataService.sharedInstance.addThePostToFirebase(postID:  (mallIIDJson["jobId"]?.stringValue)!)
            let status: Int = Int(responseDict.value(forKeyPath: "myHashMap.status") as! String)!
            if status == 1{
                CXDataService.sharedInstance.hideLoader()
            }else{
            }
            CXDataService.sharedInstance.hideLoader()
            completion(true)
        }
        //  }
    }
    
    
    func upladTheImage(){
        
        
    }
    
    func imageUpload( imageData:Data,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
        let mutableRequest : AFHTTPRequestSerializer = AFHTTPRequestSerializer()
        let request1 : NSMutableURLRequest =    mutableRequest.multipartFormRequest(withMethod: "POST", urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getphotoUploadUrl(), parameters: ["refFileName":String.generateBoundaryString()], constructingBodyWith: { (formatData:AFMultipartFormData) in
            formatData.appendPart(withFileData: imageData, name: "srcFile", fileName: "uploadedFile.jpg", mimeType: "image/jpeg")
        }, error: nil)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request1 as URLRequest) {
            (
            data, response, error) in
            
            /*  guard let : NSData = data as NSData?, let :URLResponse = response  , error == nil else {
             print("error")
             return
             }*/
            
            if (data != nil){
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let myDic = dataString?.convertStringToDictionary()  //self.convertStringToDictionary(dataString! as String)
                completion(myDic!)
            }else{
                completion(NSDictionary())
            }

        }
        task.resume()
        
    }
}


//MARK: Get Restaurants
extension LFDataManager{
    //MARK: Get All Restaruants from Server
    func getTheAllRestarantsFromServer(completion:@escaping (_ responseDict:[Restaurants]) -> Void){
        //http://35.160.251.153:8081/services/getallmallshelper
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+"services/getMasters?type=allMalls", parameters: ["":"" as AnyObject]) { (responseDict) in
           // print(responseDict)
            //orgs
            let orgs : NSArray = (responseDict.value(forKey: "orgs") as?NSArray)!
            LFDataSaveManager.sharedInstance.savePlacesInDB(list: orgs)
            var restarurantsLists = [Restaurants]()
            for resData in orgs{
                let restaurants = Restaurants(json: JSON(resData))
                restarurantsLists.append(restaurants)
            }
            completion(restarurantsLists)
        }
    }
    
    func sharePost(jsonDic:NSDictionary,imageData:Data,hastTagString:String,completion:@escaping (_ responseDict:Bool) -> Void){
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"User Posts" as AnyObject,"json":String.genarateJsonString(dataDic: jsonDic) as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Products" as AnyObject,"userId":"3" as AnyObject,"consumerEmail": CXAppConfig.sharedInstance.getEmailID() as AnyObject,"hashTags":hastTagString as AnyObject]) { (responseDict) in
            let resultDic = JSON(responseDict)
            
            let mallIIDJson  = resultDic["myHashMap"].dictionary! as [String:JSON]
            print(mallIIDJson)
            //LFFireBaseDataService.sharedInstance.addThePostToFirebase(postID:  (mallIIDJson["jobId"]?.stringValue)!)
            let status: Int = Int(responseDict.value(forKeyPath: "myHashMap.status") as! String)!
            if status == 1{
                CXDataService.sharedInstance.hideLoader()
            }else{
            }
            CXDataService.sharedInstance.hideLoader()
            completion(true)
        }
        //  }
    }
    
    //http://35.160.251.153:8081/Services/getMasters?mallId=4&type=Stores
    func getTheRestaurantLocationsFromServer(restaurantId:String,completion:@escaping (_ responseDict:[RestaurantsLocation]) -> Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getMasterUrl(), parameters: ["mallId":restaurantId as AnyObject, "type":"Stores" as AnyObject]) { (responseDict) in
            print(responseDict)
            let orgs : NSArray = (responseDict.value(forKey: "jobs") as? NSArray)!
            var restarurantsLists = [RestaurantsLocation]()
            for resData in orgs{
                let restaurants = RestaurantsLocation(locationJson: JSON(resData))
                restarurantsLists.append(restaurants)
            }
            completion(restarurantsLists)
        }
    }
    
    //    func serviceAPICall(PageNumber: NSString, PageSize: NSString)

    //MARK: Get all home feeds from server
    func getTheHomeFeed(pageNumber:String,pageSize:String,userEmail:String,isNearByFeed:Bool,nearByMallsLatLong:String, completion:@escaping ([LFFeedsData])->Void){
        
        if isNearByFeed{
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getNearByFeed(),parameters:["type":"User Posts" as AnyObject,"NearByMalls":nearByMallsLatLong as AnyObject,"pageNumber":pageNumber as AnyObject,"pageSize":pageSize as AnyObject]) { (responceDic
                ) in
                let orgs : NSArray = (responceDic.value(forKey: "jobs") as?NSArray)!
                var feedsList = [LFFeedsData]()
                for resData in orgs{
                    let restaurants = LFFeedsData(json: JSON(resData))
                    feedsList.append(restaurants)
                }
                
                LFDataSaveManager.sharedInstance.saveNearFeedsInDB(list: feedsList)
                //self.getAllFoodies()
                completion(feedsList)
                
                CXDataService.sharedInstance.hideLoader()
            }
        }else{
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getHomeFeed(), parameters: ["email":userEmail as AnyObject,"pageNumber":pageNumber as AnyObject,"pageSize":pageSize as AnyObject]) { (responceDic
                ) in
                
                let orgs : NSArray = (responceDic.value(forKey: "jobs") as?NSArray)!
                var feedsList = [LFFeedsData]()
                for resData in orgs{
                    let restaurants = LFFeedsData(json: JSON(resData))
                    feedsList.append(restaurants)
                }
                LFDataSaveManager.sharedInstance.saveHomeFeedsInDB(list: feedsList)
                //self.getAllFoodies()
                completion(feedsList)
                CXDataService.sharedInstance.hideLoader()
            }
        }
    }
 
    //myPosts=true
    
    //MARK: Get all Restaurant Foodie Photos feeds from server
    func getTheRFoodiePhotoFeed(id:String, pageNumber:String,pageSize:String,completion:@escaping ([LFFeedsData])->Void){
        print(id,pageNumber,pageSize)
        let num = Int(id)
        let subAdminId = String(num! + 1)
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getMasterUrl(), parameters: ["type":"User Posts" as AnyObject,"mallId":id as AnyObject, "subAdminId":subAdminId as AnyObject,"pageNumber":pageNumber as AnyObject,"pageSize":pageSize as AnyObject]) { (responseDict) in
            let orgs : NSArray = (responseDict.value(forKey: "jobs") as?NSArray)!
            var feedsList = [LFFeedsData]()
            for resData in orgs{
                let restaurants = LFFeedsData(json:JSON(resData))
                feedsList.append(restaurants)
            }
            
            LFDataSaveManager.sharedInstance.saveHomeFeedsInDB(list: feedsList)
            completion(feedsList)
            CXDataService.sharedInstance.hideLoader()
            
        }
    }
    
    
    //MARK: Get Like Update for Posts
    func getPostLike(orgID:String,jobID:String,isLike:Bool,completion:@escaping (Bool,NSDictionary)->Void){
        
        var noOfLikes = String()
        if isLike {
            noOfLikes = "1"
        }
        else {
            noOfLikes = "-1"
        }
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPostLikeApi(), parameters: ["orgId":orgID as AnyObject,"userId":CXAppConfig.sharedInstance.getUserID() as AnyObject,"jobId":jobID as AnyObject,"noOfLikes":noOfLikes as AnyObject,"type":"like" as AnyObject]) { (responceDic) in
            
            print(responceDic)
            if responceDic.value(forKey: "status") as! String == "1" {
                completion(true,responceDic)
            }
            else {
                completion(false,responceDic)
            }
            
            }
        
        CXDataService.sharedInstance.hideLoader()
        }
    
    
    //MARK: Get Like Update for Posts
    func deleteComment(commentId:String,completion:@escaping (Bool)->Void){
        //// http://localhost:8081/ Jobs/removeJobComment? commentId= 23223
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getDeleteComment(), parameters: ["commentId":commentId as AnyObject]) { (responceDic) in
            print(responceDic)
            
            if responceDic.value(forKey: "status") as! String == "1" {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }

    //MARK: Get All Foodies from Server

    func getSearchFoodie(keyword:String,pageNumber:String,pageSize:String,completion:@escaping ([SearchFoodies])->Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getMasterUrl(), parameters: ["mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject, "type":"MacIdInfo" as AnyObject,"keyWord":keyword as AnyObject,"pageNumber":pageNumber as AnyObject,"pageSize":pageSize as AnyObject]) { (responceDic
            ) in
            print("Search Data is \(responceDic)")
            let orgs : NSArray = (responceDic.value(forKey: "jobs") as?NSArray)!
            var feedsList = [SearchFoodies]()
            for resData in orgs{
                let restaurants = SearchFoodies(json: JSON(resData))
                feedsList.append(restaurants)
            }
            completion(feedsList)
            CXDataService.sharedInstance.hideLoader()
        }
    }
    //MARK: getAllFoodies
    
    func getAllFoodies(){
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getMasterUrl(), parameters: ["mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject, "type":"MacIdInfo" as AnyObject,"keyWord":"" as AnyObject]) { (responceDic
            ) in
            print("Search Data is \(responceDic)")
            let orgs : NSArray = (responceDic.value(forKey: "jobs") as?NSArray)!
            var feedsList = [SearchFoodies]()
            for resData in orgs{
                let restaurants = SearchFoodies(json: JSON(resData))
                feedsList.append(restaurants)
            }
            LFDataSaveManager.sharedInstance.saveFoodieDetailsInDB(foodiesData: feedsList)
        }
    }
    
    
    //MARK : FORGOOT PASSWORD
    func  forgotPassword(_ email:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getForgotPassordUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"email":email as AnyObject,"dt":"DEVICES" as AnyObject]) { (responseDict) in
            completion(responseDict)
            
        }
    }
    
    
    //MARK: Follow
    
    func followTheUser(foodieDetails:AnyObject,isFromHome:Bool){
        // http://35.160.251.153:8081/Services/createORGetJobInstance?email=yasaswy.gunturi@gmail.com&orgId=2&activityName=User_Follow&loyalty=true&ItemCodes=1b14164f-4216-4aa0-bc6a-07c16ab506c6&trackOnlyOnce=true
        
        if isFromHome{
            let itemCode = (foodieDetails as! LFFoodies).foodieItemCode
            let userFollowDic = ["email":CXAppConfig.sharedInstance.getEmailID(),"orgId":CXAppConfig.sharedInstance.getAppMallID(),"activityName":"User_Follow","loyalty":"true","ItemCodes":itemCode,"trackOnlyOnce":"true"];
            
            CXDataService.sharedInstance.followOrUnFollowServiceCall(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserFollowApi(), parameters: userFollowDic as [String : AnyObject]?) { (response) in
                
                // print(response)
                if response {
                    LFDataSaveManager.sharedInstance.saveFollowerInfoInDB(userData: foodieDetails,isFollower:false,isFromHome: true, completion: { (dic) in
                        // completion(responseDict)
                        
                    })
                }
                else {
                    
                }
                // print(response)
            }
        }else{
            let userFollowDic = ["email":CXAppConfig.sharedInstance.getEmailID(),"orgId":CXAppConfig.sharedInstance.getAppMallID(),"activityName":"User_Follow","loyalty":"true","ItemCodes":(foodieDetails as! SearchFoodies).foodieItemCode,"trackOnlyOnce":"true"];
            CXDataService.sharedInstance.followOrUnFollowServiceCall(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserFollowApi(), parameters: userFollowDic as [String : AnyObject]?) { (response) in
                if response {
                    LFDataSaveManager.sharedInstance.saveFollowerInfoInDB(userData: foodieDetails,isFollower:false,isFromHome:false, completion: { (dic) in
                    })
                }
            }
        }
    }
    
    func sendTheFollwAndUnFollowPushNotification(isFollow:Bool,foodieDetails:SearchFoodies){
        //http://localhost:8081/MobileAPIs/sendNotificationToUser?mallId=2&toUserId=&message=Successfully%20added%20your%20device&title=Test
        
         let notificationDic = ["toUserId":"33","mallId":CXAppConfig.sharedInstance.getAppMallID(),"message":"hi","title":"hello"];
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.pushNotificationSendApi(), parameters: notificationDic as [String : AnyObject]?) { (dataDic) in
            
        }
        
        
    }
    
    //MARK: UnFollow
    func unFollowTheUser(foodieDetails:AnyObject,isFromHome:Bool){
        //http://35.160.251.153:8081/Services/deleteJobInstanceOrActivity?email=yasaswy.gunturi@gmail.com&orgId=2&activityName=User_Follow&loyalty=true&ItemCodes=1b14164f-4216-4aa0-bc6a-07c16ab506c6&trackOnlyOnce=false
        
        if isFromHome{
            let userUnFollowDic = ["email":CXAppConfig.sharedInstance.getEmailID(),"orgId":CXAppConfig.sharedInstance.getAppMallID(),"activityName":"User_Follow","loyalty":"true","ItemCodes":(foodieDetails as! LFFoodies).foodieItemCode,"trackOnlyOnce":"true"];
            
            CXDataService.sharedInstance.followOrUnFollowServiceCall(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserUnFollowApi(), parameters: userUnFollowDic as [String : AnyObject]?) { (response) in
                
                // print(response)
                if response {
                    let predicate = NSPredicate.init(format: "followerUserId = %@ AND isFollowing=true", (foodieDetails as! LFFoodies).foodieUserId)
                    let realm = try! Realm()
                    let data = realm.objects(LFFollowers.self).filter(predicate)
                    let obj = data.first
                    try! realm.write {
                        realm.delete(obj!)
                    }
                }
                else {
                    
                }
            }
        }else{
            let userUnFollowDic = ["email":CXAppConfig.sharedInstance.getEmailID(),"orgId":CXAppConfig.sharedInstance.getAppMallID(),"activityName":"User_Follow","loyalty":"true","ItemCodes":(foodieDetails as! SearchFoodies).foodieItemCode,"trackOnlyOnce":"true"];
            
            CXDataService.sharedInstance.followOrUnFollowServiceCall(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserUnFollowApi(), parameters: userUnFollowDic as [String : AnyObject]?) { (response) in
                
                // print(response)
                if response {
                    let predicate = NSPredicate.init(format: "followerUserId = %@ AND isFollowing=true", (foodieDetails as! SearchFoodies).foodieUserId)
                    
                    let realm = try! Realm()
                    let data = realm.objects(LFFollowers.self).filter(predicate)
                    let obj = data.first
                    try! realm.write {
                        realm.delete(obj!)
                    }
                }
                else {
                    
                }
            }
        }
    }
    
    //MARK:Get Followers
    //http://localhost:8081/MobileAPIs/getFollowers?email=sriram.badeti@gmail.com&macId=9711fdc1-f0dc-49ae-99dc-524224e541d1
    
    func getFollowers(completion:@escaping (_ response:Bool) -> Void){
        
        //macId = Item code in macId info
        let followerDic = ["email":CXAppConfig.sharedInstance.getEmailID(),"macId":CXAppConfig.sharedInstance.getuserMacID()]
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserFollowers(), parameters: followerDic as [String : AnyObject]?) { (responseDict) in
           // print(responseDict)
            
            let userData = responseDict.value(forKey: "jobs") as! NSArray
            if userData.count > 0 {
                LFDataSaveManager.sharedInstance.saveFollowerInfoInDBFromService(userData: userData,isFollower:true, completion: { (dic) in
                     completion(true)
                })
                
            }
            
        }
    }
    //MARK: Get Followings
    //http://localhost:8081/MobileAPIs/getFollowing?email=sriram.badeti@gmail.com
    
    func getFollowings(completion:@escaping (_ response:Bool) -> Void){
        
        let followingDic = ["email":CXAppConfig.sharedInstance.getEmailID()]
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserFollowings(), parameters: followingDic as [String : AnyObject]?) { (responseDict) in
            //print(responseDict)
            
            let userData = responseDict.value(forKey: "jobs") as! NSArray
            if userData.count > 0 {
                LFDataSaveManager.sharedInstance.saveFollowerInfoInDBFromService(userData: userData,isFollower:false, completion: { (dic) in
                    completion(true)
                })
                
            }
            
        }
    }
    
    //MARK: saving followers/following details into DB
    //saving followers/following details into DB
    func saveFollowerInfoInDBFromService(userData:NSArray,isFollower:Bool,completion:@escaping () -> Void){
        
        MagicalRecord.save({ (localContext) in
            for i in 0...userData.count - 1 {
                let dict = userData[i] as! NSDictionary
                
                let enFollower =  NSEntityDescription.insertNewObject(forEntityName: "Followers", into: localContext!) as? Followers
                enFollower?.followerId = CXAppConfig.resultString(input: dict.value(forKey:"id")! as AnyObject)
                enFollower?.followerEmail = dict.value(forKey:"Email") as? String
                enFollower?.followerName = dict.value(forKey:"FullName") as? String
                enFollower?.followerImage = dict.value(forKey:"Image") as? String
                enFollower?.followerItemCode =  dict.value(forKey:"ItemCode") as? String
                enFollower?.followerUserId = CXAppConfig.resultString(input: dict.value(forKey:"UserId")! as AnyObject)
                enFollower?.noOfFollowers = CXAppConfig.resultString(input: dict.value(forKey:"followers")! as AnyObject)
                enFollower?.noOfFollowings = CXAppConfig.resultString(input: dict.value(forKey:"following")! as AnyObject)
                
                if isFollower {
                    enFollower?.isFollower = true
                    enFollower?.isFollowing = false
                }
                else {
                    enFollower?.isFollower = false
                    enFollower?.isFollowing = true
                }
            }
            
            
        }) { (success, error) in
            if success == true {
                completion()
            } else {
            }
        }
        
    }
    
    func saveFollowerInfoInDB(userData:SearchFoodies,isFollower:Bool,completion:@escaping () -> Void){
        
        
        MagicalRecord.save({ (localContext) in
            
            let enFollower =  NSEntityDescription.insertNewObject(forEntityName: "Followers", into: localContext!) as? Followers
            enFollower?.followerId = CXAppConfig.resultString(input: userData.foodieId as AnyObject)
            enFollower?.followerEmail = userData.foodieEmail
            enFollower?.followerName = userData.foodieName
            enFollower?.followerImage = userData.foodieImage
            enFollower?.followerItemCode =  userData.foodieItemCode
            enFollower?.followerUserId = CXAppConfig.resultString(input: userData.foodieUserId as AnyObject)
            enFollower?.noOfFollowers = CXAppConfig.resultString(input: userData.foodieFollowerCount as AnyObject)
            enFollower?.noOfFollowings = CXAppConfig.resultString(input: userData.foodieFollowingCount as AnyObject)
            
            if isFollower {
                enFollower?.isFollower = true
                enFollower?.isFollowing = false
            }
            else {
                enFollower?.isFollower = false
                enFollower?.isFollowing = true
            }
            
            
            
        }) { (success, error) in
            if success == true {
                completion()
            } else {
            }
        }
    }
    
    //MARK: Get User Posts
    func getUserPosts(userEmail:String,myPosts:Bool,otherPosts:Bool,pageNumber:String,pageSize:String,completion:@escaping (_ responce:Bool,_ results:[LFFeedsData]) -> Void){
  
        var parameterDic = [String:String]()
        if myPosts == true {
            parameterDic = ["email":userEmail,"myPosts":"true"]
        }else{
            parameterDic = ["email":userEmail]
        }
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getHomeFeed(), parameters: parameterDic as [String : AnyObject]?) { (responceDic
            ) in
            //print("Get Data is \(responceDic)")
            
            let orgs : NSArray = (responceDic.value(forKey: "jobs") as?NSArray)!
            var feedsList = [LFFeedsData]()
            for resData in orgs{
                let restaurants = LFFeedsData(json: JSON(resData))
                feedsList.append(restaurants)
            }
            
            if myPosts && !otherPosts {
               LFDataSaveManager.sharedInstance.saveTheUserPhotos(list: feedsList)
            }
            
        // LFDataSaveManager.sharedInstance.saveTheUserUploadPosts(feedDataList: feedsList)
            
            // self.jobsArray = responceDic.value(forKey: "jobs") as! NSArray
           // completion(feedsList)
            CXDataService.sharedInstance.hideLoader()
            completion(true, feedsList)
        }
    }
    
    //get The other user posts
    //http://localhost:8081/MobileAPIs/getUserPosts?email=cxsample@gmail.com&myPosts=true&pageNumber=1&pageSize=2
    
    
    //MAR:get UserDetails From MacIdinfo
    //http://apps.storeongo.com:8081/Services/getMasters?mallId=6&type=MacIdInfo&keyWord=yash.yash@yash.com
    //"privateToUser": "yash.yash@yash.com",
    
    func getTheUserDetails(userEmail:String,completion:@escaping (_ isUniqueKeyGenarated:Bool)->Void){
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"macidinfo" as AnyObject,"keyWord":userEmail as AnyObject]) { (responceData) in
            
            let resultArray : NSArray = NSArray(array: (responceData.value(forKey: "jobs") as? NSArray)!)
            
            for mackIDInfoDic in resultArray {
                let dic : NSDictionary = mackIDInfoDic as! NSDictionary
                let email: String = (dic.object(forKey: "Email") as? String)!
                if  email == userEmail {
                    //Save The User Data
                    LFDataSaveManager.sharedInstance.saveTheUserDetails(userDataDic: JSON(dic))
                    self.sendTheDeviceTokenToServer()
                    completion(true)
                    return
                }
            }
        }
    }
    
    func getTheParticularUserData(userEmail:String,completion:@escaping(_ isSuccess:Bool) -> Void){
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"macidinfo" as AnyObject,"keyWord":userEmail as AnyObject]) { (responceData) in
            let resultArray : NSArray = NSArray(array: (responceData.value(forKey: "jobs") as? NSArray)!)
            
            for mackIDInfoDic in resultArray {
                let dic : NSDictionary = mackIDInfoDic as! NSDictionary
                let email: String = (dic.object(forKey: "Email") as? String)!
                if  email == userEmail {
                    //Save The User Data in LFFoodie Details
                    print(dic)
                    var feedsList = [SearchFoodies]()
                    let restaurants = SearchFoodies(json: JSON(dic))
                    feedsList.append(restaurants)
                    LFDataSaveManager.sharedInstance.saveFoodieDetailsInDB(foodiesData: feedsList)
                    completion(true)
                    return
                }
            }
        }
    }

    func getFollowersDetails()
    {
        self.getFollowings { (response) in

        }
        
        self.getFollowers(completion: { (resp) in
            
        })
    }
    
    //MARK : CHANGE PASSWORD
    func  changePassword(email:String,currentPsw:String,newPsw:String,confirmPsw:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getChangePassword(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"dt":"DEVICES" as AnyObject,"cPassword":currentPsw as AnyObject,"nPassword":newPsw as AnyObject,"nrPassword":confirmPsw as AnyObject,"email":email as AnyObject]) { (responseDict) in
            completion(responseDict)
        }
    }
    
    //MARK : Update Multiple properties
    
    func getUpdateMultipleProperties(jobId:String,jsonString:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUpdatedUserDetails(), parameters: ["jobId":jobId as AnyObject, "jsonString":jsonString as AnyObject,"ownerId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responceDic) in
            completion(responceDic)
        }
    }
    
    
    //MARK: Send the Device token
    func sendTheDeviceTokenToServer(){
        
        //http://35.160.251.153:8081/MobileAPIs/saveUserDeviceInfo?mallId=2
        //        device_reg_id
        //        deviceMacId
        //        deviceUserId
        //deviceType="IOS"
        
        let realm = try! Realm()
        let profile = realm.objects(LFMyProfile.self).first
        
        let device_reg_id = CXAppConfig.sharedInstance.getDeviceToken()
        let deviceMacId = UIDevice.current.identifierForVendor?.uuidString
        let deviceUserId = profile?.Mac_userId

        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+"MobileAPIs/saveUserDeviceInfo?", parameters: ["mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"device_reg_id":device_reg_id as AnyObject,"deviceMacId":deviceMacId as AnyObject,"deviceUserId":deviceUserId as AnyObject,"deviceType":"IOS" as AnyObject]) { (responseDict) in
          //  print(responseDict)
        }
    }
    
    func deleteTheDeviceTokenFromServer(){
        
      //: http://35.160.251.153:8081/MobileAPIs/deleteUserDeviceInfo?mallId=&deviceMacId=&deviceUserId=
        let realm = try! Realm()
        let profile = realm.objects(LFMyProfile.self).first
       // let device_reg_id = CXAppConfig.sharedInstance.getDeviceToken()
        let deviceMacId = UIDevice.current.identifierForVendor?.uuidString
        let deviceUserId = profile?.Mac_userId
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+"MobileAPIs/deleteUserDeviceInfo?", parameters: ["mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"deviceMacId":deviceMacId as AnyObject,"deviceUserId":deviceUserId as AnyObject]) { (responseDict) in
            print(responseDict)
        }
    }
    
    // MARK: Post Comment
    //http://35.160.251.153:8081/jobs/saveJobCommentJSON?jobId=1116&comment=Hi&&macId=4f3864a2-b8cc-41b7-922d-38a82d0d4258
    func postComment(jobId:String,comment:String,macId:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.postCommentsApi(), parameters: ["jobId": jobId as AnyObject,"comment":comment as AnyObject,"macId":macId as AnyObject]) { (responseDict) in
             completion(responseDict)
        }
    }
    
    // MARK: Get Commnets
    //http://35.160.251.153:8081/services/getMasters?jobId=915
    func getComments(feedId:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getMasterUrl(), parameters: ["jobId": feedId as AnyObject]) { (responseDict) in
            completion(responseDict)
        }
    }
    
    //MARK: Get all hashtag Data from server
    func getTheHAshTagDataFromServer(PageNumber: String,PageSize:String,HashTag:String,completion:@escaping ([LFFeedsData])->Void){
        
        //http://35.160.251.153:8081/Services/getMasters?type=User%20Posts&keyWord=iOSTeam
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getMasterUrl(), parameters: ["type":"User Posts" as AnyObject,"keyWord":HashTag as AnyObject,"pageNumber":PageNumber as AnyObject,"pageSize":PageSize as AnyObject]) { (responceDic) in
            
            let orgs : NSArray = (responceDic.value(forKey: "jobs") as?NSArray)!
            var feedsList = [LFFeedsData]()
            for resData in orgs{
                let restaurants = LFFeedsData(json: JSON(resData))
                feedsList.append(restaurants)
            }
            LFDataSaveManager.sharedInstance.saveHomeFeedsInDB(list: feedsList)
            completion(feedsList)
            // print("response Data >>>>> \(responceDic)")
            CXDataService.sharedInstance.hideLoader()
        }
        
        
    }
    
    //MARK: Getting All HashTags Data from Server

    func getHashTagDataFromServer()
    {
        let urlStr = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getHashTagsApi()
        CXDataService.sharedInstance.getAppDataFromServerUsingURL(urlStr) { (responseDic) in
            print(responseDic)
            let hashArray = responseDic.value(forKey: "hashTags") as! NSArray
            LFDataSaveManager.sharedInstance.saveHashTagInfoInDB(hashTagsArr: hashArray)
            
        }
    }
    
    //MARK: Getting All UserNames Data from Server
    
    func getUserNamesDataFromServer()
    {
        let urlStr = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getUserNamesApi()
        CXDataService.sharedInstance.getAppDataFromServerUsingURL(urlStr) { (responseDic) in
            print(responseDic)
            let userNamesArray = responseDic.value(forKey: "tags") as! NSArray
            LFDataSaveManager.sharedInstance.saveUserNamesInfoInDB(userNamesArr: userNamesArray)
            
        }
    }

    
    //MARK: Getting HashTags data from server using search keyword and saving in DB
    func getHashTagDataFromServerUsingKeyword(keyword:String,completion:@escaping (Bool)->Void)
    {
        let urlStr = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getHashTagsApiUsingKeyword()
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(urlStr, parameters: ["keyWord":keyword as AnyObject]) { (responseDic) in
            let hashArray = responseDic.value(forKey: "hashTags") as! NSArray
            LFDataSaveManager.sharedInstance.saveHashTagInfoInDB(hashTagsArr: hashArray)
            completion(true)
        }
    }
    
    //MARK: Getting UserNames data from server using search Keyword
    
    func getUserNameDataFromServerUsingKeyword(keyword:String,completion:@escaping (Bool)->Void)
    {
        let urlStr = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getUserNamesApiUsingKeyword()
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(urlStr, parameters: ["keyWord":keyword as AnyObject]) { (responseDic) in
            let userNamesArray = responseDic.value(forKey: "tags") as! NSArray
            LFDataSaveManager.sharedInstance.saveUserNamesInfoInDB(userNamesArr: userNamesArray)
            completion(true)
        }
    }
}

extension LFDataManager {
    
    // http://localhost:8081/MobileAPIs/postAQuestionAndAnswer?ownerId=530&toEmail=cxsample@gmail.com&fromEmail=satyasasi.b@gmail.com&question=what%20is%20java
    
    //MARK: PostQuestion OR Answer
    func postQuestionsAndAnswers(ownerId:String,toEmail:String ,fromEmail:String ,questionOrAnswer:String ,questionID:String ,isQuestion:Bool,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        // This method for post a Question or Answer
        //ownerId
        //toEmail
        //fromEmail
        //question
        //qaaId
        
        var postedQuestionOrAnswerDic = [String:String]()
        if isQuestion {
            //Is Question
            postedQuestionOrAnswerDic = ["ownerId":ownerId,"toEmail":toEmail,"fromEmail":fromEmail,"question":questionOrAnswer]
        }else{
            //Is Answer
            postedQuestionOrAnswerDic = ["ownerId":ownerId,"toEmail":toEmail,"fromEmail":fromEmail,"answer":questionOrAnswer,"qaaId":questionID]
        }
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getpostAQuestionAndAnswer(), parameters: postedQuestionOrAnswerDic as [String : AnyObject]?) { (dic) in
            completion(dic)
        }
    }
    
    //MARK: GetQuestion And Answers
    //http://localhost:8081/MobileAPIs/getPostedQuestions?ownerId=530&email=satyasasi.b@gmail.com
    
    func getPosterQuestions(ownerId:String,email:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        let postedQuestionOrAnswerDic = ["ownerId":ownerId,"email":email]
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getPostedQuestions(), parameters: postedQuestionOrAnswerDic as [String : AnyObject]?) { (dic) in
            completion(dic)
        }
    }
    
    
    func getPostedAnswers(ownerId:String,email:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        let postedQuestionOrAnswerDic = ["ownerId":ownerId,"email":email]
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getgetPostedAnswers(), parameters: postedQuestionOrAnswerDic as [String : AnyObject]?) { (dic) in
            completion(dic)
        }
    }

}


