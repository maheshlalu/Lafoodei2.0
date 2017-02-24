//
//  CXDataService.swift
//  FanTicket
//
//  Created by apple on 09/12/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
private var _SingletonSharedInstance:CXDataService! = CXDataService()

class CXDataService: NSObject {
    let timeOutInterval : Int = 60
    var progress : MBProgressHUD!
    class var sharedInstance : CXDataService {
        return _SingletonSharedInstance
    }
    
    func showLoader(view:UIView,message:String){
        
        self.progress = MBProgressHUD.showAdded(to: view, animated: true)
        self.progress.mode = MBProgressHUDMode.indeterminate
        self.progress.labelText = message
        self.progress.show(animated: true)
        
        
    }
    
    func hideLoader(){
        self.progress.hide(animated: true)
    }
    
    
    open func getTheAppDataFromServer(_ parameters:[String: AnyObject]? = nil ,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        if Bool(1) {
            print(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getMasterUrl())
            print(parameters)
            
            //            KRProgressHUD.show(progressHUDStyle: .black, maskType: .black, activityIndicatorStyle: .white, font: CXAppConfig.sharedInstance.appMediumFont(), message: "", image: nil) {
            //
            //            }
            //
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 10//60*60
            
            let sessionManager = Alamofire.SessionManager(configuration: configuration)
            
            // Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            // Alamofire.request("https://httpbin.org/post", parameters: parameters, encoding: URLEncoding.httpBody)
            
            Alamofire.request(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getMasterUrl(), method: .post, parameters: parameters, encoding: URLEncoding.`default`)
                .responseJSON { response in
                    //to get status code
                    switch (response.result) {
                    case .success:
                        //to get JSON return value
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            //completion((response.result.value as? NSDictionary)!)
                            completion(JSON)
                            // KRProgressHUD.dismiss()
                        }
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCancelled{
                            //timeout here
                            // KRProgressHUD.dismiss()
                            self.showAlertView(status: 0)
                        }
                        if error._code == NSURLErrorNetworkConnectionLost{
                            self.showAlertView(status: 0)
                            
                        }
                        print("\n\nAuth request failed with error:\n \(error)")
                        break
                    }
            }
            
            
            // Alamofire.request("",method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: [:])
        }
    }
    
    open func synchDataToServerAndServerToMoblile(_ urlstring:String, parameters:[String: AnyObject]? = nil ,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
       print(urlstring)
        print(parameters)
        Alamofire.request(urlstring, method: .post, parameters: parameters!, encoding: URLEncoding.httpBody)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch (response.result) {
                case .success:
                    //to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        //completion((response.result.value as? NSDictionary)!)
                        completion(JSON)
                    }
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        //timeout here
                    }
                    print("\n\nAuth request failed with error:\n \(error)")
                    break
                }
                
        }
        
    }
    
    open func followOrUnFollowServiceCall(_ urlstring:String, parameters:[String: AnyObject]? = nil ,completion:@escaping (_ response:Bool) -> Void){
        
      //  print(urlstring)
       // print(parameters)
        Alamofire.request(urlstring, method: .post, parameters: parameters!, encoding: URLEncoding.httpBody)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch (response.result) {
                case .success:
                    completion(true)
                    
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        //timeout here
                        completion(false)
                    }
                    print("\n\nAuth request failed with error:\n \(error)")
                    break
                }
                
        }
        
    }
    
    func showAlertView(status:Int) {
        self.hideLoader()
        let alert = UIAlertController(title:"Network Error!!!", message:"Please bear with us.Thank You!!!", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            if status == 1 {
                
            }else{
                
            }
        }
        alert.addAction(okAction)
        //self.present(alert, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    /*Auth request failed with error:
     Error Domain=NSURLErrorDomain Code=-1001 "The request timed out." UserInfo={NSUnderlyingError=0x608000e59d40 {Error Domain=kCFErrorDomainCFNetwork Code=-1001 "(null)" UserInfo={_kCFStreamErrorCodeKey=-2102, _kCFStreamErrorDomainKey=4}}, NSErrorFailingURLStringKey=http://35.160.251.153:8081/MobileAPIs/getUserPosts?, NSErrorFailingURLKey=http://35.160.251.153:8081/MobileAPIs/getUserPosts?, _kCFStreamErrorDomainKey=4, _kCFStreamErrorCodeKey=-2102, NSLocalizedDescription=The request timed out.}
     clicked<Lefoodie.LFSearchViewController: 0x7fb460f0dc20>
     clicked<UINavigationController: 0x7fb462*/
    
    
 
    
}



