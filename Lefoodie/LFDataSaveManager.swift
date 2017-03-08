//
//  LFDataSaveManager.swift
//  Lefoodie
//
//  Created by apple on 15/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import SwiftyJSON
import MagicalRecord
import RealmSwift
private var savedManager:LFDataSaveManager! = LFDataSaveManager()

class LFDataSaveManager: NSObject {

    class var sharedInstance : LFDataSaveManager {
        return savedManager
    }
    
    
    func saveTheUserUploadPosts(feedDataList: [LFFeedsData]){
       
        let relamInstance = try! Realm()
        for feedDta in feedDataList {
            try! relamInstance.write({
                let myProfileData = LFMyProfile()
                myProfileData.userLastName = feedDta.feedUserName
                relamInstance.add(myProfileData)
            })
        }
    }
    
    
    func saveTheUserDetails(userDataDic:JSON){
        
        // LFMyProfile
        let relamInstance = try! Realm()
        // Query Realm for userProfile contains name
        let userData = relamInstance.objects(LFMyProfile.self).filter("userId=='\(userDataDic["id"].stringValue)'")
        if userData.count == 0 {
            //Insert The Data
            try! relamInstance.write({
                let myProfileData = LFMyProfile()
                myProfileData.userId = userDataDic["id"].stringValue
                myProfileData.Mac_userId = userDataDic["UserId"].stringValue
                myProfileData.userItemCode = userDataDic["ItemCode"].stringValue
                
                myProfileData.userEmail = userDataDic["Email"].stringValue
                myProfileData.userPassword = userDataDic["password"].stringValue
                myProfileData.userName = userDataDic["Name"].stringValue
                myProfileData.userLastName = userDataDic["lastName"].stringValue
                myProfileData.userFirstName = userDataDic["firstName"].stringValue
                myProfileData.userMobileNumber = userDataDic["mobileNo"].stringValue

                myProfileData.userPic = userDataDic["Image"].stringValue

                myProfileData.userFollowers = userDataDic["followers"].stringValue
                myProfileData.userFollwing = userDataDic["following"].stringValue
                myProfileData.userDOB = userDataDic["DOB"].stringValue
                myProfileData.userBannerPic = userDataDic["userBannerPath"].stringValue

                relamInstance.add(myProfileData)
            })
        }
        
    }
    
    
    func saveTheUserPhotos(list:[LFFeedsData]){
        let relamInstance = try! Realm()
        for feedData in list {
            let userData = relamInstance.objects(LFUserPhotos.self).filter("feedID=='\(feedData.feedID)'")
            if userData.count == 0 {
                //Insert The Data
                try! relamInstance.write({
                    let userPhotos = LFUserPhotos()
                    userPhotos.feedID = feedData.feedID
                    userPhotos.feedName = feedData.feedName
                    userPhotos.feedImage = feedData.feedImage
                    userPhotos.feedItemCode = feedData.feedItemCode
                    userPhotos.feedUserEmail = feedData.feedUserEmail
                    relamInstance.add(userPhotos)
                })
            }
        }
        // LFMyProfile
        // Query Realm for userProfile contains name
   

    }
    
    func saveHomeFeedsInDB(list:[LFFeedsData]){
       
        //Get user ID
        
        let relamInstance = try! Realm()
        let myProfile = try! Realm().objects(LFMyProfile.self).first

        for feedData in list {
            let userData = relamInstance.objects(LFHomeFeeds.self).filter("feedID=='\(feedData.feedID)'")
            self.saveTheUserLikedPosts(feedData: feedData, userId: (myProfile?.Mac_userId)!)
            LFFireBaseDataService.sharedInstance.addPostActivity(isUpdateComment: false, isLikeCount: true, isFavorites: false, postID: feedData.feedID)

            if userData.count == 0 {
                //Insert The Data
                try! relamInstance.write({
                    let homeFeed = LFHomeFeeds()
                    homeFeed.feedID = feedData.feedID
                    homeFeed.feedItemCode = feedData.feedItemCode
                    homeFeed.feedCreatedDate = feedData.feedCreatedDate
                    homeFeed.feedModificationDate = feedData.feedModificationDate
                    homeFeed.feedName = feedData.feedName
                    homeFeed.feedImage = feedData.feedImage
                    homeFeed.feedDescription = feedData.feedDescription
                    homeFeed.feedFavaouritesCount = feedData.feedFavaouritesCount
                    homeFeed.feedCommentsCount = feedData.feedCommentsCount
                    homeFeed.feedLikesCount = feedData.feedLikesCount
                    homeFeed.feedIDMallID = feedData.feedIDMallID
                    homeFeed.feedIDMallName = feedData.feedIDMallName
                    homeFeed.feedIDMallImage = feedData.feedIDMallImage
                    homeFeed.feedUserName = feedData.feedUserName
                    homeFeed.feedUserImage = feedData.feedUserImage
                    homeFeed.feedUserEmail = feedData.feedUserEmail
                    relamInstance.add(homeFeed)
                })
            }
        }

    }
    
    func saveTheUserLikedPosts(feedData:LFFeedsData,userId:String){
        
        let likesArray = feedData.feedJson["likes"].array
        for dic in likesArray! {
            if dic["userId"].stringValue == userId {
                let relamInstance = try! Realm()
                let userData = relamInstance.objects(LFLikes.self).filter("jobId=='\(feedData.feedID))'")
                if userData.count == 0 {
                    try! relamInstance.write({
                        let like = LFLikes()
                        like.jobId = feedData.feedID
                        relamInstance.add(like)
                    })
                    
                }
                return
            }
            
        }
        
    }
    
    
    
    
    func saveFoodieDetailsInDB(foodiesData:[SearchFoodies]) {
        let relamInstance = try! Realm()
        for foodie in foodiesData {
            let userData = relamInstance.objects(LFFoodies.self).filter("foodieId=='\(foodie.foodieId)'")
            if userData.count == 0 {
            try! relamInstance.write({
                let foodieObj = LFFoodies()
                foodieObj.foodieId = foodie.foodieId
                foodieObj.foodieItemCode = foodie.foodieItemCode
                foodieObj.foodieUserId = foodie.foodieUserId
                foodieObj.foodieCreatedById = foodie.foodieCreatedById
                foodieObj.foodieJobTypeId = foodie.foodieJobTypeId
                foodieObj.foodieName = foodie.foodieName
                foodieObj.foodieDescription = foodie.foodieDescription
                foodieObj.foodieImage = foodie.foodieImage
                foodieObj.foodieMobile = foodie.foodieMobile
                foodieObj.foodieAddress = foodie.foodieAddress
                foodieObj.foodieCity = foodie.foodieCity
                foodieObj.foodieCountry = foodie.foodieCountry
                foodieObj.foodieState = foodie.foodieState
                foodieObj.foodieFirstName = foodie.foodieFirstName
                foodieObj.foodieLastName = foodie.foodieLastName
                foodieObj.foodieEmail = foodie.foodieEmail
                foodieObj.foodieCurrentJobStatus = foodie.foodieCurrentJobStatus
                foodieObj.foodieCurrentJobStatusId = foodie.foodieCurrentJobStatusId
                foodieObj.foodieFollowingCount = foodie.foodieFollowingCount
                foodieObj.foodieFollowerCount = foodie.foodieFollowerCount
               // foodieObj.jSON = CXAppConfig.sharedInstance.convertDictionayToString(dictionary: foodie)

                relamInstance.add(foodieObj)
            })
            }
        }
        
    }

    
    func savePlacesInDB(list:NSArray){
        let relamInstance = try! Realm()
        for i in 0...list.count - 1 {
            let dict = list[i] as! NSDictionary
            let placesData = relamInstance.objects(LFPlaces.self).filter("id=='\(dict.value(forKey: "id")!)'")
            if placesData.count == 0 {
            //Insert The Data
            try! relamInstance.write({
                let place = LFPlaces()
                place.id = dict.value(forKey: "id") as! String
                place.category = dict.value(forKey: "category") as! String
                place.image = dict.value(forKey: "logo") as! String
                relamInstance.add(place)
            })
            }
        }
    }
    
    func saveFollowerInfoInDB(userData:AnyObject,isFollower:Bool,isFromHome:Bool,completion:@escaping () -> Void){
        
        let relamInstance = try! Realm()
        if isFromHome{
            let foodieData = relamInstance.objects(LFFollowers.self).filter("followerId=='\(CXAppConfig.resultString(input: (userData as! LFFoodies).foodieId as AnyObject))'")
            if foodieData.count == 0 {
                //Insert The Data
                try! relamInstance.write({
                    let enFollower = LFFollowers()
                    enFollower.followerId = CXAppConfig.resultString(input: (userData as! LFFoodies).foodieId as AnyObject)
                    enFollower.followerEmail = (userData as! LFFoodies).foodieEmail
                    enFollower.followerName = (userData as! LFFoodies).foodieName
                    enFollower.followerImage = (userData as! LFFoodies).foodieImage
                    enFollower.followerItemCode =  (userData as! LFFoodies).foodieItemCode
                    enFollower.followerUserId = CXAppConfig.resultString(input: (userData as! LFFoodies).foodieUserId as AnyObject)
                    enFollower.noOfFollowers = CXAppConfig.resultString(input: (userData as! LFFoodies).foodieFollowerCount as AnyObject)
                    enFollower.noOfFollowings = CXAppConfig.resultString(input: (userData as! LFFoodies).foodieFollowingCount as AnyObject)
                    
                    if isFollower {
                        enFollower.isFollower = true
                        enFollower.isFollowing = false
                    }
                    else {
                        enFollower.isFollower = false
                        enFollower.isFollowing = true
                    }
                    
                    relamInstance.add(enFollower)
                })
            }
        }else{
            let foodieData = relamInstance.objects(LFFollowers.self).filter("followerId=='\(CXAppConfig.resultString(input: (userData as! SearchFoodies).foodieId as AnyObject))'")
            
            if foodieData.count == 0 {
                //Insert The Data
                try! relamInstance.write({
                    let enFollower = LFFollowers()
                    enFollower.followerId = CXAppConfig.resultString(input: (userData as! SearchFoodies).foodieId as AnyObject)
                    enFollower.followerEmail = (userData as! SearchFoodies).foodieEmail
                    enFollower.followerName = (userData as! SearchFoodies).foodieName
                    enFollower.followerImage = (userData as! SearchFoodies).foodieImage
                    enFollower.followerItemCode =  (userData as! SearchFoodies).foodieItemCode
                    enFollower.followerUserId = CXAppConfig.resultString(input: (userData as! SearchFoodies).foodieUserId as AnyObject)
                    enFollower.noOfFollowers = CXAppConfig.resultString(input: (userData as! SearchFoodies).foodieFollowerCount as AnyObject)
                    enFollower.noOfFollowings = CXAppConfig.resultString(input: (userData as! SearchFoodies).foodieFollowingCount as AnyObject)
                    
                    if isFollower {
                        enFollower.isFollower = true
                        enFollower.isFollowing = false
                    }
                    else {
                        enFollower.isFollower = false
                        enFollower.isFollowing = true
                    }
                    
                    relamInstance.add(enFollower)
                })
            }
        }
    }
    
    func saveFollowerInfoInDBFromService(userData:NSArray,isFollower:Bool,completion:@escaping () -> Void){
        
        let relamInstance = try! Realm()
        
        for i in 0...userData.count - 1 {
            let dict = userData[i] as! NSDictionary
            
            let foodieData = relamInstance.objects(LFFollowers.self).filter("followerId=='\(CXAppConfig.resultString(input: dict.value(forKey:"id")! as AnyObject))'")
            
            if foodieData.count == 0 {
                //Insert The Data
                try! relamInstance.write({
                    let enFollower = LFFollowers()
                    enFollower.followerId = CXAppConfig.resultString(input: dict.value(forKey:"id")! as AnyObject)
                    enFollower.followerEmail = (dict.value(forKey:"Email") as? String)!
                    enFollower.followerName = (dict.value(forKey:"FullName") as? String)!
                    enFollower.followerImage = (dict.value(forKey:"Image") as? String)!
                    enFollower.followerItemCode =  (dict.value(forKey:"ItemCode") as? String)!
                    enFollower.followerUserId = CXAppConfig.resultString(input: dict.value(forKey:"UserId")! as AnyObject)
                    enFollower.noOfFollowers = CXAppConfig.resultString(input: dict.value(forKey:"followers")! as AnyObject)
                    enFollower.noOfFollowings = CXAppConfig.resultString(input: dict.value(forKey:"following")! as AnyObject)
                    
                    if isFollower {
                        enFollower.isFollower = true
                        enFollower.isFollowing = false
                    }
                    else {
                        enFollower.isFollower = false
                        enFollower.isFollowing = true
                    }
                    
                    relamInstance.add(enFollower)
                })
            }

        }
        
}



    

    
/*
    Delete the Data in Realm 
     
     let realm = try! Realm()
     
     let userData = realm.objects(LFMyProfile.self)
     
     try! realm.write {
     realm.delete(userData)
     }

     
     // Define your models like regular Swift classes
     class Dog: Object {
     dynamic var name = ""
     dynamic var age = 0
     }
     class Person: Object {
     dynamic var name = ""
     dynamic var picture: NSData? = nil // optionals supported
     let dogs = List<Dog>()
     }
     
     // Use them like regular Swift objects
     let myDog = Dog()
     myDog.name = "Rex"
     myDog.age = 1
     print("name of dog: \(myDog.name)")
     
     // Get the default Realm
     let realm = try! Realm()
     
     // Query Realm for all dogs less than 2 years old
     let puppies = realm.objects(Dog.self).filter("age < 2")
     puppies.count // => 0 because no dogs have been added to the Realm yet
     
     // Persist your data easily
     try! realm.write {
     realm.add(myDog)
     }
     
     // Queries are updated in realtime
     puppies.count // => 1
     
     // Query and update from any thread
     DispatchQueue(label: "background").async {
     let realm = try! Realm()
     let theDog = realm.objects(Dog.self).filter("age == 1").first
     try! realm.write {
     theDog!.age = 3
     }
     }
     */
    
    
    
}
