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

private var sharedManager:LFDataManager! = LFDataManager()

class LFDataManager: NSObject {

    class var sharedInstance : LFDataManager {
        return sharedManager
    }
    
}

//MARK: Share Post
extension LFDataManager{
    /*
     dt=CAMPAIGNS&type=User Posts&category=Products&userId=6&json={"list":[{"Name":"Good product","Image":"http:\/\/35.160.251.153:8085\/coin\/files\/null\/android\/uploads\/2_profilePic.jpg","storeId":"4"}]}&consumerEmail="nadapananagababu@gmail.com"
     */
    
    func sharePost(jsonDic:NSDictionary,imageData:Data,completion:@escaping (_ responseDict:Bool) -> Void){
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"User Posts" as AnyObject,"json":String.genarateJsonString(dataDic: jsonDic) as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Products" as AnyObject,"userId":"6" as AnyObject,"consumerEmail": CXAppConfig.sharedInstance.getEmailID() as AnyObject]) { (responseDict) in
            print(responseDict)
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
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let myDic = dataString?.convertStringToDictionary()  //self.convertStringToDictionary(dataString! as String)
            completion(myDic!)
        }
        task.resume()
        
    }
}


//MARK: Get Restaurants
extension LFDataManager{
    //MARK: Get All Restaruants from Server
    func getTheAllRestarantsFromServer(completion:@escaping (_ responseDict:[Restaurants]) -> Void){
        //http://35.160.251.153:8081/services/getallmallshelper
        
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+"services/getallmallshelper", parameters: ["":"" as AnyObject]) { (responseDict) in
            print(responseDict)
            //orgs
            let orgs : NSArray = (responseDict.value(forKey: "orgs") as?NSArray)!
            var restarurantsLists = [Restaurants]()
            for resData in orgs{
                let restaurants = Restaurants(json: JSON(resData))
                restarurantsLists.append(restaurants)
            }
            completion(restarurantsLists)
        }
    }
    
    //    func serviceAPICall(PageNumber: NSString, PageSize: NSString)

    //MARK: Get all home feeds from server
    func getTheHomeFeed(pageNumber:String,pageSize:String,userEmail:String,completion:@escaping ([LFFeedsData])->Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getHomeFeed(), parameters: ["email":userEmail as AnyObject]) { (responceDic
            ) in
            print("Get Data is \(responceDic)")
            
            let orgs : NSArray = (responceDic.value(forKey: "jobs") as?NSArray)!
            var feedsList = [LFFeedsData]()
            for resData in orgs{
                let restaurants = LFFeedsData(json: JSON(resData))
                feedsList.append(restaurants)
            }
            
           // self.jobsArray = responceDic.value(forKey: "jobs") as! NSArray
            completion(feedsList)
            CXDataService.sharedInstance.hideLoader()
        }
    }
    

    //MARK: Get All Foodies from Server

    func getSearchFoodie(keyword:String,completion:@escaping ([SearchFoodies])->Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getMasterUrl(), parameters: ["mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject, "type":"MacIdInfo" as AnyObject,"keyWord":keyword as AnyObject]) { (responceDic
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
    
    
    //MARK : FORGOOT PASSWORD
    func  forgotPassword(_ email:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getForgotPassordUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"email":email as AnyObject,"dt":"DEVICES" as AnyObject]) { (responseDict) in
            completion(responseDict)
            
        }
    }
    
    
    //Follow
    
    func followTheUser(otherUserItemCode:String){
   // http://35.160.251.153:8081/Services/createORGetJobInstance?email=yasaswy.gunturi@gmail.com&orgId=2&activityName=User_Follow&loyalty=true&ItemCodes=1b14164f-4216-4aa0-bc6a-07c16ab506c6&trackOnlyOnce=true
        
        
        let userFollowDic = ["email":CXAppConfig.sharedInstance.getEmailID(),"orgId":CXAppConfig.sharedInstance.getAppMallID(),"activityName":"User_Follow","loyalty":"true","ItemCodes":otherUserItemCode,"trackOnlyOnce":"true"];
        print(userFollowDic)

        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserFollowApi(), parameters: userFollowDic as [String : AnyObject]?) { (responce) in
            
            print(responce)
        }
    }
    
    
    func unFollowTheUser(otherUserItemCode:String){
        //http://35.160.251.153:8081/Services/deleteJobInstanceOrActivity?email=yasaswy.gunturi@gmail.com&orgId=2&activityName=User_Follow&loyalty=true&ItemCodes=1b14164f-4216-4aa0-bc6a-07c16ab506c6&trackOnlyOnce=false
        
        let userUnFollowDic = ["email":CXAppConfig.sharedInstance.getEmailID(),"orgId":CXAppConfig.sharedInstance.getAppMallID(),"activityName":"User_Follow","loyalty":"true","ItemCodes":otherUserItemCode,"trackOnlyOnce":"true"];
        print(userUnFollowDic)

        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserUnFollowApi(), parameters: userUnFollowDic as [String : AnyObject]?) { (responce) in
            print(responce)

        }
        
    }
    
    //Get Followers
    //http://localhost:8081/MobileAPIs/getFollowers?email=sriram.badeti@gmail.com&macId=9711fdc1-f0dc-49ae-99dc-524224e541d1
    
    func getFollowers()
    {
        //macId = Item code in macId info
            let followerDic = ["email":CXAppConfig.sharedInstance.getEmailID(),"macId":CXAppConfig.sharedInstance.getuserMacID()]
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserFollowers(), parameters: followerDic as [String : AnyObject]?) { (responseDict) in
            print(responseDict)
            
            let userData = responseDict.value(forKey: "jobs") as! NSArray
            if userData.count > 0 {
                self.saveFollowerInfoInDB(userData: userData,isFollower:true, completion: { (dic) in
                    // completion(responseDict)
                })

            }
        
        }
    }
    
    //Get Followings
    //http://localhost:8081/MobileAPIs/getFollowing?email=sriram.badeti@gmail.com
    
    func getFollowings()
    {
        let followingDic = ["email":CXAppConfig.sharedInstance.getEmailID()]
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserFollowings(), parameters: followingDic as [String : AnyObject]?) { (responseDict) in
            print(responseDict) 
            
            let userData = responseDict.value(forKey: "jobs") as! NSArray
            if userData.count > 0 {
                self.saveFollowerInfoInDB(userData: userData,isFollower:false, completion: { (dic) in
                    // completion(responseDict)
                })
                
            }
            
        }
    }
    
    //saving followers/following details into DB
    func saveFollowerInfoInDB(userData:NSArray,isFollower:Bool,completion:@escaping () -> Void){
        let jobsArray = userData.value(forKey: "jobs") as! NSArray
    
        MagicalRecord.save({ (localContext) in
            for i in 0...jobsArray.count - 1 {
                let dict = jobsArray[i] as! NSDictionary
            
            let enFollower =  NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: localContext!) as? Followers
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
    
    func getOtherPosts(){
        
    }
    
    //get The other user posts
    //http://localhost:8081/MobileAPIs/getUserPosts?email=cxsample@gmail.com&myPosts=true&pageNumber=1&pageSize=2
    
}



