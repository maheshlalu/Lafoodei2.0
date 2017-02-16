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
        let realm = try! Realm()
        // Query Realm for userProfile contains name
        let userData = realm.objects(LFMyProfile.self).filter("userId=='\(userDataDic["id"].stringValue)'")
        if userData.count == 0 {
            //Insert The Data
            let relamInstance = try! Realm()
            try! relamInstance.write({
                let myProfileData = LFMyProfile()
                myProfileData.userId = userDataDic["id"].stringValue
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

                relamInstance.add(myProfileData)
            })
        }
        
    }
    
    /*
     /*
     
     id: 327,
     ItemCode: "e9ff366c-211a-490d-8b66-9806b5990d5d",
     UserId: "30",
     createdById: 2,
     jobTypeId: 83,
     jobTypeName: "MacIdInfo",
     createdByFullName: "LeFoodie",
     publicURL: "http://35.160.251.153/app/2/Devices;MacIdInfo;327;_;SingleProduct",
     privateToUser: "balachandrabhogapurapu@gmail.com",
     PackageName: "",
     Name: "BHOGAPURAPU BALACHANDRA",
     password: "102043852215875143164",
     Image: "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg",
     Description: "",
     FullName: "BHOGAPURAPU BALACHANDRA",
     mobileNo: "",
     address: "",
     city: "",
     state: "",
     country: "",
     firstName: "BHOGAPURAPU",
     lastName: "BALACHANDRA",
     userBannerPath: "",
     lattitude: "",
     Email: "balachandrabhogapurapu@gmail.com",
     gender: "0",
     longitude: "",
     hrsOfOperation: [ ],
     Attachments: [ ],
     Additional_Details: { },
     jobComments: [ ],
     Current_Job_Status: "Active",
     Current_Job_StatusId: 165,
     Next_Seq_Nos: "2",
     CreatedSubJobs: [ ],
     Next_Job_Statuses: [],
     Insights: [ ],
     overallRating: "0.0",
     totalReviews: "0",
     following: 5,
     followers: 1,
     favourites: [ ],
     favouritesCount: 0,
     malldetails: {},
     macIdInfodetails: ""     */
     

     
     */
    
    
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
