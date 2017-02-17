//
//  LFMyProfile.swift
//  Lefoodie
//
//  Created by apple on 14/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import RealmSwift


class LFMyProfile: Object {
    
    dynamic var userId = ""
    dynamic var userItemCode = ""
    dynamic var macId = ""

    dynamic var userEmail = ""
    dynamic var userName = ""
    dynamic var userFirstName = ""
    dynamic var userLastName = ""
    dynamic var userPassword = ""
    dynamic var userMobileNumber = ""

    dynamic var userPic = ""
    dynamic var json = ""
    dynamic var userBannerPic = ""
    
    dynamic var userFollowers = ""
    dynamic var userFollwing = ""
    dynamic var userDOB = ""


    
// Specify properties to ignore (  won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    
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
    
}
