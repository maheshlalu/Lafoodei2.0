//
//  LFFeedsData.swift
//  Lefoodie
//
//  Created by apple on 09/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class  LFFeedsData{

    var feedID : String
    var feedItemCode : String
    var feedCreatedDate : String
    var feedModificationDate : String
    var feedName : String
    var feedImage : String
    var feedDescription : String
    var feedFavaouritesCount : String
    var feedCommentsCount : String
    var feedLikesCount : String
    var feedIDMallID : String
    var feedIDMallName : String
    var feedIDMallImage : String
    var feedUserEmail : String
    var feedUserName : String
    var feedUserImage : String
    var feedPublicUrl : String
    var feedIDMallEmail : String
    var feedJson : JSON

    
    init(json: JSON) {
        feedID = json["id"].stringValue
        feedItemCode = json["ItemCode"].stringValue
        feedCreatedDate = json["createdOn"].stringValue
        feedModificationDate = json["lastModifiedDate"].stringValue
        feedName = json["Name"].stringValue
        feedImage = json["Image"].stringValue
        feedDescription = json["Description"].stringValue
        feedFavaouritesCount =  json["favouritesCount"].stringValue //(json["favouritesCount"].array?.count)!
        feedCommentsCount = json["jobCommentsCount"].stringValue
        feedLikesCount = json["likesCount"].stringValue
        feedPublicUrl = json["publicURL"].stringValue
        
//        print(feedCommentsCount)
//        print(feedLikesCount)
//        print(feedFavaouritesCount)
        
        let mallIIDJson  = json["malldetails"].dictionary! as [String:JSON]
        feedIDMallID = (mallIIDJson["id"]?.stringValue)!
        feedIDMallName = (mallIIDJson["fullname"]?.stringValue)!
        feedIDMallImage = (mallIIDJson["logo"]?.stringValue)!
        feedIDMallEmail = (mallIIDJson["email"]?.stringValue)!
        
        let userDataJson  = json["macIdInfodetails"].dictionary! as [String:JSON]
        feedUserName = json["createdByFullName"].stringValue
        feedUserEmail = (userDataJson["email"]?.stringValue)!
        feedUserImage = (userDataJson["image"]?.stringValue)!
        feedJson = json
    }
}


/*
 id: 395,
 ItemCode: "b56c0aec-9edf-408a-acc5-3a5e16614af4",
 createdOn: "15:32 Feb 8, 2017",
 lastModifiedDate: "08-2-2017 15:32:12:00",
 createdById: 33,
 jobTypeId: 251,
 jobTypeName: "User Posts",
 createdByFullName: "yernagulamahesh",
 publicURL: "http://35.160.251.153/app/6/Products;UserPosts;395;_;SingleProduct",
 PackageName: "",
 Name: "",
 Image: "http://35.160.251.153:8085/coin/files/null/android/uploads/5CD5C2A7-BCC5-4C05-BF91-2E5EB314DFFD.jpg",
 Description: "",
 Quantity: "",
 MRP: "",
 CategoryType: "",
 storeId: "",
 SubCategoryType: "",
 P3rdCategory: "",
 ServiceType: "",
 hrsOfOperation: [ ],
 Attachments: [ ],
 Additional_Details: { },
 jobComments: [ ],
 Current_Job_Status: "Active",
 Current_Job_StatusId: 583,
 Next_Seq_Nos: "2",
 CreatedSubJobs: [ ],
 Next_Job_Statuses: [],
 Insights: [],
 overallRating: "0.0",
 totalReviews: "0",
 favourites: [ ],
 favouritesCount: 0,
 malldetails: {
 id: "6",
 fullname: "ninjasushi",
 email: "ninjasushi_sog@ongo.com",
 website: "http://ninjasushiroseville.com/",
 subdomain: "ongo_6",
 logo: "http://35.160.251.153:8085/coin/files/6/users/profilePics/6_1485774108845.jpg"
 },
 macIdInfodetails: {
 name: "Yernagulamahesh Yernagulamahesh",
 email: "yernagulamahesh@gmail.com",
 image: "https://lh3.googleusercontent.com/-S368cTqik1s/AAAAAAAAAAI/AAAAAAAAAGE/F2SCGi21XKQ/photo.jpg",
 mobileNo:
 */
