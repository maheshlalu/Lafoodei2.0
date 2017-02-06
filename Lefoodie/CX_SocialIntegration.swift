//
//  CX_SocialIntegration.swift
//  FitSport
//
//  Created by apple on 09/11/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit
import MagicalRecord
private var _SingletonSharedInstance:CX_SocialIntegration! = CX_SocialIntegration()

class CX_SocialIntegration: NSObject {
    
    
    class var sharedInstance : CX_SocialIntegration {
        return _SingletonSharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    //MARK: FACEBOOK
    func applicationRegisterWithFaceBook(userDataDic : NSDictionary,completion:@escaping (_ resPonce:Bool) -> Void) {
        //Before register with facebook check The MACID info API call
        // http://storeongo.com:8081/Services/getMasters?type=macidinfo&mallId=17018
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type" : "macidinfo" as AnyObject,"mallId" : CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            let email: String = (userDataDic.object(forKey: "email") as? String)!
            
            if !self.checkTheUserRegisterWithApp(userEmail: email, macidInfoResultDic:responseDict).isRegistred {
                //Register with app
                let strFirstName: String = (userDataDic.object(forKey: "first_name") as? String)!
                let strLastName: String = (userDataDic.object(forKey: "last_name") as? String)!
               // let gender: String = (userDataDic.object(forKey: "gender") as? String)!
                let email: String = (userDataDic.object(forKey: "email") as? String)!
                let fbID : String = (userDataDic.object(forKey: "id") as? String)!
                let userPic : String = (userDataDic.value(forKeyPath: "picture.data.url") as? String)!
                
                //picture,data,url
                let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email,"DEVICES",fbID,strFirstName,strLastName,"",userPic,"true"],
                                                                 forKeys: ["orgId" as NSCopying,"userEmailId" as NSCopying,"dt" as NSCopying,"password" as NSCopying,"firstName" as NSCopying,"lastName" as NSCopying,"gender" as NSCopying,"filePath" as NSCopying,"isLoginWithFB" as NSCopying])
                self.registerWithSocialNewtWokrk(registerDic: userRegisterDic, completion: { (responseDict) in
                    completion(true)
                    
                })
                //self.profileImageStr = (responseDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
             //   print("Welcome,\(email) \(strFirstName) \(strLastName) \(gender) ")
            }else{
                // get the details from server using below url
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"email":email as AnyObject,"dt":"DEVICES" as AnyObject,"isLoginWithFB":"true" as AnyObject]) { (responseDict) in
                    //"password":""
                    self.saveUserDeatils(userData: responseDict, completion: { (dic) in
                        completion(false)
                    })
                    
                }
                //http://localhost:8081/MobileAPIs/loginConsumerForOrg?email=cxsample@gmail.com&orgId=530&dt=DEVICES&isLoginWithFB=true
            }
            
        }
        
    }
    
    
    //MARK: SignUp
    func applicationRegisterWithSignUp(userDataDic : NSDictionary,completion:@escaping (_ resPonce:Bool) -> Void) {
        //Before register with facebook check The MACID info API call
        // http://storeongo.com:8081/Services/getMasters?type=macidinfo&mallId=17018
        
        
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type" : "macidinfo" as AnyObject,"mallId" : CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"keyWord" : userDataDic.object(forKey: "userEmailId")! as AnyObject]) { (responseDict) in
            print(responseDict)
            let email: String = (userDataDic.object(forKey: "userEmailId") as? String)!
            
            if !self.checkTheUserRegisterWithApp(userEmail: email, macidInfoResultDic:responseDict).isRegistred {
                
                
                //Register with app
                let strFirstName: String = (userDataDic.object(forKey: "firstName") as? String)!
                let strLastName: String = (userDataDic.object(forKey: "lastName") as? String)!
                let gender: String = (userDataDic.object(forKey: "gender") as? String)!
                let email: String = (userDataDic.object(forKey: "userEmailId") as? String)!
                let passwd : String = (userDataDic.object(forKey: "password") as? String)!

                
                //picture,data,url
                let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email,"DEVICES",passwd,strFirstName,strLastName,gender,"","false"],
                                                                 forKeys: ["orgId" as NSCopying,"userEmailId" as NSCopying,"dt" as NSCopying,"password" as NSCopying,"firstName" as NSCopying,"lastName" as NSCopying,"gender" as NSCopying,"filePath" as NSCopying,"isLoginWithFB" as NSCopying])
                self.registerWithSocialNewtWokrk(registerDic: userRegisterDic, completion: { (responseDict) in
                    completion(true)
                    
                })
                //self.profileImageStr = (responseDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                //   print("Welcome,\(email) \(strFirstName) \(strLastName) \(gender) ")
            }else{
                completion(false)
                // get the details from server using below url
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"email":email as AnyObject,"dt":"DEVICES" as AnyObject,"isLoginWithFB":"false" as AnyObject]) { (responseDict) in
                    //"password":""
                    
                    self.saveUserDeatils(userData: responseDict, completion: { (dic) in
                        completion(false)
                    })
                    
                }
                //http://localhost:8081/MobileAPIs/loginConsumerForOrg?email=cxsample@gmail.com&orgId=530&dt=DEVICES&isLoginWithFB=true
            }
            
        }
        
    }

    
    
    func checkTheUserRegisterWithApp(userEmail:String , macidInfoResultDic : NSDictionary) -> (isRegistred:Bool, userDic:NSDictionary){
        let resultArray : NSArray = NSArray(array: (macidInfoResultDic.value(forKey: "jobs") as? NSArray)!)
        for mackIDInfoDic in resultArray {
            let dic : NSDictionary = mackIDInfoDic as! NSDictionary
            let email: String = (dic.object(forKey: "Email") as? String)!
            if  email == userEmail {
                return (true,mackIDInfoDic as! NSDictionary)
            }
        }
        return (false,NSDictionary())
    }
    
    
    func registerWithSocialNewtWokrk(registerDic:NSDictionary,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignUpInUrl(), parameters: registerDic as? [String : AnyObject]) { (responseDict) in
            self.saveUserDeatils(userData: responseDict, completion: { (dic) in
                completion(responseDict)
            })
            
        }
        
    }
    
    func userLogin(loginDic:NSDictionary,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        print(loginDic)
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["dt":"DEVICES" as AnyObject,"orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"email":loginDic.value(forKey: "email")! as AnyObject,"password":loginDic.value(forKey: "password")! as AnyObject]) { (responseDict) in
            //"password":""
            MagicalRecord.save({ (localContext) in
                 UserProfile.mr_truncateAll(in: localContext)
            }) 
       
            self.saveUserDeatils(userData: responseDict, completion: { (dic) in
                completion(responseDict)
            })
            // LoadingView.hide()
        }
        //
        //        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: loginDic as? [String : AnyObject]) { (responseDict) in
        //
        //            if responseDict.value(forKey:"status") as? String == "1"{
        //                self.saveUserDeatils(responseDict)
        //                print(responseDict)
        //            }else{
        //
        //            }
        //        }
    }
    
    
    func saveUserDetailsFromMacIDInfo(userData:NSDictionary){
        
        
        MagicalRecord.save({ (localContext) in
            let enProduct =  NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: localContext!) as? UserProfile
            enProduct?.userId = CXAppConfig.resultString(input: userData.value(forKey:"id")! as AnyObject)
            enProduct?.emailId = userData.value(forKey:"Email") as? String
            enProduct?.firstName = userData.value(forKey:"firstName") as? String
            enProduct?.lastName = userData.value(forKey:"lastName") as? String
            enProduct?.userPic =  userData.object(forKey: "Image") as? String
            enProduct?.phoneNumber =  userData.object(forKey: "mobileNo") as? String
            enProduct?.macId = enProduct?.userId
            enProduct?.json = CXAppConfig.sharedInstance.convertDictionayToString(dictionary: userData) as String
            enProduct?.macIdJobId = ""
        }) { (success, error) in
            if success == true {
                
            } else {
            }
        }
    }
    
    func saveUserDeatils(userData:NSDictionary,completion:@escaping () -> Void){
        MagicalRecord.save({ (localContext) in
            let enProduct =  NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: localContext!) as? UserProfile
            print(userData)
            
            let status: Int = Int(userData.value(forKey: "status") as! String)!
            
            if status == 1{
                enProduct?.userId = CXAppConfig.resultString(input: userData.value(forKey:"UserId")! as AnyObject)
                enProduct?.emailId = userData.value(forKey:"emailId") as? String
                enProduct?.firstName = userData.value(forKey:"firstName") as? String
                enProduct?.lastName = userData.value(forKey:"lastName") as? String
                enProduct?.userPic =  userData.object(forKey: "userImagePath") as? String
                enProduct?.macId = userData.value(forKey:"macId") as? String
                enProduct?.json = CXAppConfig.sharedInstance.convertDictionayToString(dictionary: userData) as String
                enProduct?.macIdJobId = CXAppConfig.resultString(input: userData.value(forKey:"macIdJobId")! as AnyObject)
                CXAppConfig.sharedInstance.saveUserID(userID: (enProduct?.userId)!)
                CXAppConfig.sharedInstance.saveMacJobID(macJobId: (enProduct?.macIdJobId)!)
            }
        }) { (success, error) in
            if success == true {
                completion()
            } else {
            }
        }
        
    }
    
    //MARK: Google Plus
    
    func applicationRegisterWithGooglePlus(userDataDic : NSDictionary,completion:@escaping (_ resPonce:Bool) -> Void) {
        /*
         {
         email = "yernagulamahesh@gmail.com";
         "email_verified" = 1;
         "family_name" = Yernagulamahesh;
         gender = male;
         "given_name" = Yernagulamahesh;
         locale = "en-GB";
         name = "Yernagulamahesh Yernagulamahesh";
         picture = "https://lh3.googleusercontent.com/-S368cTqik1s/AAAAAAAAAAI/AAAAAAAAAGE/F2SCGi21XKQ/photo.jpg";
         profile = "https://plus.google.com/114362920567871916688";
         sub = 114362920567871916688;
         }
         */
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type" : "macidinfo" as AnyObject
            ,"mallId" : CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                let email: String = (userDataDic.object(forKey: "email") as? String)!
                
                if !self.checkTheUserRegisterWithApp(userEmail: email, macidInfoResultDic: responseDict).isRegistred {
                    //Register with app
                    let strFirstName: String =  userDataDic["given_name"] as! String
                    
                    let strLastName: String = userDataDic["family_name"] as! String
                    //let gender: String =  userDataDic["gender"] as! String
                    let email: String = (userDataDic.object(forKey: "email") as? String)!
                    let GoogleID : String = (userDataDic.object(forKey: "sub") as? String)!
                    let userPic : String = (userDataDic.object(forKey: "picture") as? String)!
                    
                    //picture,data,url
                    
                    let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email,"DEVICES",GoogleID,strFirstName,strLastName,"",userPic,"true",userPic],
                                                                     forKeys: ["orgId" as NSCopying,"userEmailId" as NSCopying,"dt" as NSCopying,"password" as NSCopying,"firstName" as NSCopying,"lastName" as NSCopying,"gender" as NSCopying,"filePath" as NSCopying,"isLoginWithFB" as NSCopying,"userImagePath" as NSCopying])
                    print(userRegisterDic)
                    self.registerWithSocialNewtWokrk(registerDic: userRegisterDic, completion: { (responseDict) in
                        completion(true)
                        
                    })                //self.profileImageStr = (responseDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                    print("Welcome,\(email) \(strFirstName) \(strLastName)  ")
                }else{
                    // get the details from server using below url
                    
                    CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"email":email as AnyObject,"dt":"DEVICES" as AnyObject,"isLoginWithFB":"true" as AnyObject]) { (responseDict) in
                        //"password":""
                        self.saveUserDeatils(userData: responseDict, completion: { (dic) in
                            completion(false)
                        })
                        
                    }
                    //http://localhost:8081/MobileAPIs/loginConsumerForOrg?email=cxsample@gmail.com&orgId=530&dt=DEVICES&isLoginWithFB=true
                }
                
        }
        
        
    }
    
    //MARK:OTP Functionality
    
    // Varifying Email
    func varifyingEmailForOTP(comsumerEmailId:String, completion:@escaping (_ responseDict:NSDictionary) -> Void) {
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getVarifyingEmailOTP(), parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail":comsumerEmailId as AnyObject]) { (responseDict) in
            print(responseDict)
            completion(responseDict)
            
        }
    }
    
    // Sending OTP
    func sendingOTPToGivenNumber(consumerEmailId:String, mobile:String, completion:@escaping (_ responseDict:NSDictionary) -> Void){
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSendingOTP(), parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail":consumerEmailId as AnyObject,"mobile":"91\(mobile)" as AnyObject]) { (responseDict) in
            print(responseDict)
            completion(responseDict)
        }
        
    }
    
    // Validating OTP
    func validatingRecievedOTP(consumerEmailId:String, enteredOTP:String, completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getComparingOTP(), parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail":consumerEmailId as AnyObject,"otp":enteredOTP as AnyObject]) { (responseDict) in
            print(responseDict)
            completion(responseDict)
            
        }
    }
    
}
