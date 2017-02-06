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
    
    func sharePost(jsonDic:NSDictionary,imageData:Data){
    
      //  self.imageUpload(imageData: imageData) { (Response) in
           // let imgStr = Response.value(forKey: "filePath") as! String
            let dict:NSMutableDictionary = NSMutableDictionary()
            dict.setObject("Good product", forKey: "Name" as NSCopying)
            dict.setObject("http://35.160.251.153:8085/coin/files/null/android/uploads/4FC77B50-18C4-43BD-8647-5C15257D26E1.jpg", forKey: "Image" as NSCopying)
            dict.setObject("4", forKey: "storeId" as NSCopying)
            //dict.setObject(mobile, forKey: "Phone Number" as NSCopying
            
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"User Posts" as AnyObject,"json":String.genarateJsonString(dataDic: dict) as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Products" as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail": "nadapananagababu@gmail.com" as AnyObject]) { (responseDict) in
                print(responseDict)
                let status: Int = Int(responseDict.value(forKeyPath: "myHashMap.status") as! String)!
                if status == 1{
                    // self.showAlertView("Success!!!", status: 1)
                }else{
                    //self.showAlertView("Something went wrong!! Please Try Again!!", status: 0)
                }
            }
      //  }
        
        
        
        
        /*
         http://storeongo.com:8081/MobileAPIs/postedJobs? and parameters:Optional(["dt": CAMPAIGNS, "userId": 92, "type": Enquiry, "json": {
         "list" : [
         {
         "Address" : "Test\t\t",
         "Name" : "Suresh",
         "Message" : "Test",
         "Phone number" : "9640339556"
         }
         ]
         }, "category": Services])
         (lldb)
         */

        
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

/*
 func subMitTheServiceFormData(_ serviceFormDic:NSMutableDictionary){
 
 serviceFormDic.removeObject(forKey: "Submit")
 print(serviceFormDic)
 
 let dict:NSMutableDictionary = NSMutableDictionary()
 dict.setObject(serviceFormDic.value(forKey: "Name")!, forKey: "Name" as NSCopying)
 dict.setObject(serviceFormDic.value(forKey: "Message")!, forKey: "Message" as NSCopying)
 dict.setObject(serviceFormDic.value(forKey: "Address")!, forKey: "Address" as NSCopying)
 dict.setObject(serviceFormDic.value(forKey: "Phone number")!, forKey: "Phone number" as NSCopying)
 //dict.setObject(mobile, forKey: "Phone Number" as NSCopying)
 print(dict)
 
 let listArray : NSMutableArray = NSMutableArray()
 
 listArray.add(dict)
 
 let formDict :NSMutableDictionary = NSMutableDictionary()
 formDict.setObject(listArray, forKey: "list" as NSCopying)
 
 var jsonData : Data = Data()
 do {
 jsonData = try JSONSerialization.data(withJSONObject: formDict, options: JSONSerialization.WritingOptions.prettyPrinted)
 // here "jsonData" is the dictionary encoded in JSON data
 } catch let error as NSError {
 print(error)
 }
 let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
 
 
 if UserDefaults.standard.value(forKey: "USER_EMAIL") as? String != nil {
 
 let email = UserDefaults.standard.value(forKey: "USER_EMAIL")
 CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":self.serViceCategory as AnyObject,"json":jsonStringFormat! as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Services" as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail": email as AnyObject]) { (responseDict) in
 print(responseDict)
 
 let status: Int = Int(responseDict.value(forKeyPath: "myHashMap.status") as! String)!
 
 if status == 1{
 self.showAlertView("Success!!!", status: 1)
 
 }else{
 self.showAlertView("Something went wrong!! Please Try Again!!", status: 0)
 }
 }
 
 }else{
 
 CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":self.serViceCategory as AnyObject,"json":jsonStringFormat! as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Services" as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
 print(responseDict)
 
 let status: Int = Int(responseDict.value(forKeyPath: "myHashMap.status") as! String)!
 
 if status == 1{
 self.showAlertView("Success!!!", status: 1)
 
 }else{
 self.showAlertView("Something went wrong!! Please Try Again!!", status: 0)
 }
 }
 }
 }
 */



/*
 let params: Parameters = ["type":"User Posts" as AnyObject,"json":String.genarateJsonString(dataDic: dict) as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Products" as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail": "nadapananagababu@gmail.com" as AnyObject]
 
 // let imageData = imageData
 Alamofire.upload(multipartFormData:{ multipartFormData in
 for (key, value) in params {
 multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
 }
 //  multipartFormData.append(imageData, withName: "photo", mimeType: "image/jpg")
 multipartFormData.append(imageData, withName: "srcFile", mimeType: "image/jpeg")
 // multipartFormData.append(withFileData: imageData, name: "srcFile", fileName: "uploadedFile.jpg", mimeType: "image/jpeg")
 
 
 },
 usingThreshold:UInt64.init(),
 to: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(),
 method:.post,
 headers:nil,
 encodingCompletion: { encodingResult in
 switch encodingResult {
 case .success(let upload, _, _):
 upload.responseString(completionHandler: { response in
 print("success", response.result.value )
 })
 case .failure(let encodingError):
 print("en eroor :", encodingError)
 }
 })
 

 */
