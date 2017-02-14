//
//  CXAppConfig.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/22/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation

class CXAppConfig {
    
    /// the singleton
    static let sharedInstance = CXAppConfig()
    
    // This prevents others from using the default '()' initializer for this class.
    private init() {
        loadConfig()
    }
    
    /// the config dictionary
    var config: NSDictionary?
    
    /**
     Load config from Config.plist
     */
    func loadConfig() {
        if let path = Bundle.main.path(forResource: "CXProjectConfiguration", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)
            
           // print(config)
        }
    }
    
    /**
     Get base url from Config.plist
     
     
     
     
     
     - Returns: the base url string from Config.plist      
     */
    func getBaseUrl() -> String {
        //testBaseUrl
        // return config!.value(forKey: "BaseUrl") as! String //Production
         return config!.value(forKey: "testBaseUrl") as! String //Testing
    }
    //getMaster
    func getMasterUrl() -> String {
        return config!.value(forKey: "getMaster") as! String
    }
    
    func getSignInUrl() -> String {
        return config!.value(forKey: "signInMethod") as! String
    }
    
    func getSignUpInUrl() -> String {
        return config!.value(forKey: "signUpMethod") as! String
    }
    //    //forgotPassordMethod
    func getForgotPassordUrl() -> String {
        return config!.value(forKey: "forgotPassordMethod") as! String
    }
    
    func getPlaceOrderUrl() -> String{
        return config!.value(forKey: "placeOrder") as! String
    }
    
    //updateProfile
    
    func getupdateProfileUrl() -> String {
        return config!.value(forKey: "updateProfile") as! String
    }
    //photoUpload
    func getphotoUploadUrl() -> String {
        return config!.value(forKey: "photoUpload") as! String
    }
    //getMallID
    func getAppMallID() -> String {
        //return config!.value(forKey: "MALL_ID") as! String //Production
        return config!.value(forKey: "testMallID") as! String //Testing

        //testMallID
    }

    func productName() -> String{
        return config!.value(forKey: "PRODUCT_NAME") as! String
    }
    func getSidePanelList() -> NSArray{
        
        return config!.value(forKey: "SidePanelList") as! NSArray
    }
    
    // getOTPAPIs
    
    func getVarifyingEmailOTP() -> String{
        return config!.value(forKey: "varifyingEmailForOTP") as! String
    }
    
    func getSendingOTP() -> String{
        return config!.value(forKey: "sendingOTP") as! String
    }
    func getComparingOTP() -> String{
        return config!.value(forKey: "comparingOTP") as! String
    }

    // Updating UserDict
    
    func getUpdatedUserDetails() -> String{
        return config!.value(forKey: "updateUserDetails") as! String
    }

    
    //Get Payment URL
    
    func getPaymentGateWayUrl() -> String{
       // return config!.value(forKey: "payMentGateWay") as! String //oldPaymentURL
       return config!.value(forKey: "paymentTestBaseURL") as! String// TestUrlfor payment
       // return config!.value(forKey: "paymentProductionUrl") as! String// productionurl for payment


    }
    //paymentTestBaseURL
    func getPaymentTestBaseUrl() -> String{
        return config!.value(forKey: "paymentTestBaseURL") as! String
    }
    
    func getPaymentProductionUrl() -> String{
        return config!.value(forKey: "paymentProductionUrl") as! String
    }
    
    //createBookingHistoryByPId
    func getcreateBookingHistoryByPIdUrl() -> String{
        return config!.value(forKey: "createBookingHistoryByPId") as! String
    }
    
    
    //Get Psoted questions and Answers
    
    //paymentTestBaseURL
    func getpostAQuestionAndAnswer() -> String{
        return config!.value(forKey: "postQuestion") as! String
    }
    
    func getPostedQuestions() -> String{
        return config!.value(forKey: "getPostedQuestions") as! String
    }
    
    
    func getgetPostedAnswers() -> String{
        return config!.value(forKey: "getPostedAnswers") as! String
    }
    
    //getHomeFeeds
    func getHomeFeed() -> String{
        return config!.value(forKey: "getHomeFeeds") as! String
    }
    
    
    //userFollow
    
    func getUserFollowApi()-> String{
        return config!.value(forKey: "userFollow") as! String

    }
    
    
    //userUnFollow
    
    func getUserUnFollowApi()-> String{
        return config!.value(forKey: "userUnFollow") as! String
        
    }
  /*
    func getAppTheamColor() -> UIColor {
        
        let appTheamColorArr : NSArray = config!.value(forKey: "AppTheamColor") as! NSArray
        let red : Double = (appTheamColorArr.object(at: 0) as! NSString).doubleValue
        let green : Double = (appTheamColorArr.object(at: 1) as! NSString).doubleValue
        let blue : Double = (appTheamColorArr.object(at: 2) as! NSString).doubleValue
        return UIColor(
            red: CGFloat(red / 255.0),
            green: CGFloat(green / 255.0),
            blue: CGFloat(blue / 255.0),
            alpha: CGFloat(1.0)
        )
    }
    
    func getAppBGColor() -> UIColor {
        
        let appTheamColorArr : NSArray = config!.value(forKey: "AppBgColr") as! NSArray
        let red : Double = (appTheamColorArr.object(at: 0) as! NSString).doubleValue
        let green : Double = (appTheamColorArr.object(at: 1) as! NSString).doubleValue
        let blue : Double = (appTheamColorArr.object(at: 2) as! NSString).doubleValue
        return UIColor(
            red: CGFloat(red / 255.0),
            green: CGFloat(green / 255.0),
            blue: CGFloat(blue / 255.0),
            alpha: CGFloat(1.0)
        )
    }
    
    
    func mainScreenFrame() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    func mainScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    //MARK:FONTS
    func appSmallFont() -> UIFont{
        
        return UIFont(name: config!.value(forKey: "APPFONT_NAME_REGULAR") as! String, size: CGFloat((config!.value(forKey: "APPFONT_SMALL") as?NSNumber)!))!
        
    }
    
    func appMediumFont() -> UIFont{
        
        return UIFont(name: config!.value(forKey: "APPFONT_NAME_REGULAR") as! String, size: CGFloat((config!.value(forKey: "APPFONT_MEDIUM") as?NSNumber)!))!
    }
    

    func appLargeFont() -> UIFont{
        
        return UIFont(name: config!.value(forKey: "APPFONT_NAME_REGULAR") as! String, size: CGFloat((config!.value(forKey: "APPFONT_LARGE") as?NSNumber)!))!

    }*/
    
    
    static func resultString(input: AnyObject) -> String{
        if let value: AnyObject = input {
            var reqType : String!
            switch value {
            case let i as NSNumber:
                reqType = "\(i)"
            case let s as NSString:
                reqType = "\(s)"
            case let a as NSArray:
                reqType = "\(a.object(at: 0))"
            default:
                reqType = "Invalid Format"
            }
            return reqType
        }
        return ""
    }
    
    //MARK: User ID Saving
    func saveUserID(userID:String){
        UserDefaults.standard.set(userID, forKey: "USERID")
    }
    
    func getUserID() ->String{
        
        if(UserDefaults.standard.object(forKey: "USERID") == nil)
        {
            print("NULL")
            return ""
            
        }else{
            
            return UserDefaults.standard.value(forKey: "USERID") as! String
        }
        
    }
    
    
    //MARK: User ID Saving
    func loggedUser(userID:String){
        UserDefaults.standard.set(userID, forKey: "USERID_LOGGED")
    }
    
    func getLoggedUserID() ->String{
        
        if(UserDefaults.standard.object(forKey: "USERID_LOGGED") == nil)
        {
            print("NULL")
            return ""
            
        }else{
            
            return UserDefaults.standard.value(forKey: "USERID_LOGGED") as! String
        }
        
    }
    
    
    //MARK: User MacJob Id Saving
    func saveMacJobID(macJobId:String){
        UserDefaults.standard.set(macJobId, forKey: "MAC_JOB_ID")
    }
    
    func getMacJobID() ->String{
        
        if(UserDefaults.standard.object(forKey: "MAC_JOB_ID") == nil)
        {
            print("NULL")
            return ""
            
        }else{
            
            return UserDefaults.standard.value(forKey: "MAC_JOB_ID") as! String
        }
        
    }
    
    func setUserUpdateDict(dictionary:NSMutableDictionary){
        
        UserDefaults.standard.set(dictionary, forKey: "USER_DICT")
        
    }
    
    // MARK : User mail id saving
    func saveUserMailId(emailID:String){
    
    UserDefaults.standard.set(emailID, forKey: "EMAIL_ID")
        
    }
    
    func getEmailID() ->String{
    
        if(UserDefaults.standard.object(forKey: "EMAIL_ID") == nil){
            print("NULL")
            return ""
        }else{
        
            return UserDefaults.standard.value(forKey: "EMAIL_ID") as! String
        }
    
    }
    
    
    // MARK : User Name saving
    func saveUserName(name:String){
        
        UserDefaults.standard.set(name, forKey: "USER_NAME")
        
    }
    
    func getuserName() ->String{
        
        if(UserDefaults.standard.object(forKey: "USER_NAME") == nil){
            print("NULL")
            return ""
        }else{
            print(UserDefaults.standard.value(forKey: "USER_NAME") as! String)

            return UserDefaults.standard.value(forKey: "USER_NAME") as! String
            
                    }
      
    }
    
    // MARK : User Mac ID saving
    func saveUserMacID(macID:String){
        
        UserDefaults.standard.set(macID, forKey: "USER_MACID")
        
    }
    
    func getuserMacID() ->String{
        
        if(UserDefaults.standard.object(forKey: "USER_MACID") == nil){
            print("NULL")
            return ""
        }else{
            
            return UserDefaults.standard.value(forKey: "USER_MACID") as! String
        }
        
        
    }
    
    
    
 /*   func getUserUpdateDict() -> NSMutableDictionary {
        
        let userDict :NSMutableDictionary = UserDefaults.standard.value(forKey: "USER_DICT") as! NSMutableDictionary
        return userDict
        
    }
    
    func getTheUserData() ->(userID:String,macId:String,macIdJobId:String,userEmail:String){
        
        let appdata:NSArray = UserProfile.mr_findAll() as NSArray
        let userProfileData:UserProfile = appdata.lastObject as! UserProfile
        print(userProfileData.emailId)
        return(userID:userProfileData.userId!,macId:userProfileData.macId!,macIdJobId:userProfileData.macIdJobId!,userProfileData.emailId!)
    }
    
    func getTheUserDetails() -> UserProfile{
        
        let appdata:NSArray = UserProfile.mr_findAll() as NSArray
        let userProfileData:UserProfile = appdata.lastObject as! UserProfile
        return userProfileData
    }
    */
    
    /*How to use the above get and set methods
     
     :UPDATE:******
     
     let jsonDic : NSMutableDictionary = NSMutableDictionary(dictionary: CXAppConfig.sharedInstance.getRedeemDictionary())
     
     jsonDic.setObject(offerDic.valueForKey("Name")!, forKey: "OfferName")
     jsonDic.setObject(offerDic.valueForKey("ItemCode")!, forKey: "OfferId")
     jsonDic.setObject(offerDic.valueForKey("Code")!, forKey: "OfferCode")
     
     print(jsonDic)
     
     CXAppConfig.sharedInstance.setRedeemDictionary(jsonDic)
     
     */
    
    func convertDictionayToString(dictionary:NSDictionary) -> NSString {
        var dataString: String!
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            //print("JSON data is \(jsonData)")
            dataString = String(data: jsonData, encoding: String.Encoding.utf8)
            //print("Converted JSON string is \(dataString)")
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            dataString = ""
            print(error)
        }
        return dataString as NSString
    }
    
    func convertStringToDictionary(string:String) -> NSDictionary {
        var jsonDict : NSDictionary = NSDictionary()
        let data = string.data(using: String.Encoding.utf8)
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary            // CXDBSettings.sharedInstance.saveAllMallsInDB((jsonData.valueForKey("orgs") as? NSArray)!)
        } catch {
            //print("Error in parsing")
        }
        return jsonDict
    }
    
    func dateAndTimeConvertion(dateStr:String) -> String{

        var stringFromDate:String = String()
        let dateString = dateStr
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let dateFromString = formatter.date(from: dateString) {
            formatter.dateFormat = "dd-MM-yyyy 'at' h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            stringFromDate = formatter.string(from: dateFromString)
            print(stringFromDate)
        }
        return stringFromDate
    }
    
    //MARK - 
    
    func resultString(input: AnyObject) -> String{
        if let value: AnyObject = input {
            var reqType : String!
            switch value {
            case let i as NSNumber:
                reqType = "\(i)"
            case let s as NSString:
                reqType = "\(s)"
                break
            case let a as NSArray:
                reqType = "\(a.object(at: 0))"
                break
            default:
                reqType = "Invalid Format"
            }
            return reqType
        }
        return ""
    }
    
    func getTheDataInDictionaryFromKey(sourceDic:NSDictionary,sourceKey:NSString) ->String{
        let keyExists = sourceDic[sourceKey] != nil
        if keyExists {
            // now val is not nil and the Optional has been unwrapped, so use it
            return self.resultString(input: sourceDic[sourceKey]! as AnyObject)
        }
        return ""
        
    }
    
    
    func saveUserDataInUserDefaults(responceDic : NSDictionary){
        print("Values \(responceDic)")
        
        // Save all data
    setUserUpdateDict(dictionary: responceDic.mutableCopy() as! NSMutableDictionary)
        
        // Save individual data 
        let userID = responceDic.value(forKey: "UserId") as! NSNumber
        saveUserID(userID: String(describing: userID as NSNumber))
        let emailID = responceDic.value(forKey: "emailId") as! String
        saveUserMailId(emailID: emailID )
       let firstName = responceDic.value(forKey: "firstName") as! String
        saveUserName(name: firstName)
        let macID = responceDic.value(forKey: "macId") as! String
        saveUserMacID(macID: macID)
        let macIDjobId = responceDic.value(forKey: "macIdJobId") as! NSNumber
        saveMacJobID(macJobId: String(describing: macIDjobId as NSNumber))
        //print("user id \(userID)\(emailID)\(firstName)\(macID)\(macIDjobId)")
        
        
        
        
        
    }
    
}
