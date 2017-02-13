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
    /*
     
     let Url_base = "http://35.160.251.153:8081/MobileAPIs/getUserPosts?email=\(CXAppConfig.sharedInstance.getEmailID())"
     let urlStr = NSString.init(string: Url_base)
     CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(urlStr as String, parameters: ["":"" as AnyObject]) { (responceDic
     ) in
     print("Get Data is \(responceDic)")
     
     let orgs : NSArray = (responceDic.value(forKey: "jobs") as?NSArray)!
     var restarurantsLists = [LFFeedsData]()
     for resData in orgs{
     let restaurants = LFFeedsData(json: JSON(resData))
     restarurantsLists.append(restaurants)
     }
     
     self.jobsArray = responceDic.value(forKey: "jobs") as! NSArray
     //            let Str_Email = responceDic.value(forKey: "orgs") as! NSArray
     //            print("Email id is\(Str_Email)")
     //            self.Arr_Main = Str_Email.mutableCopy() as! NSMutableArray
     //            print("Total Arr \(self.Arr_Main)")
     CXDataService.sharedInstance.hideLoader()
     self.homeTableView.reloadData()
     }
     */
    
    
}

