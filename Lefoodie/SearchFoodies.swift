//
//  SearchFoodies.swift
//  Lefoodie
//
//  Created by Manishi on 2/13/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import SwiftyJSON

class  SearchFoodies{
    
    var foodieId : String
    var foodieItemCode : String
    var foodieUserId : String
    var foodieCreatedById : String
    var foodieJobTypeId : String
    var foodieName : String
    var foodieDescription : String
    var foodieImage : String
    var foodieMobile : String
    var foodieAddress : String
    var foodieCity : String
    var foodieCountry : String
    var foodieState : String
    var foodieFirstName : String
    var foodieLastName : String
    var foodieEmail : String
    var foodieCurrentJobStatus : String
    var foodieCurrentJobStatusId : String
    var foodieFollowingCount : String
    var foodieFollowerCount : String
    var foodieBannerImage : String
    
    init(json: JSON) {
        
        foodieId = json["id"].stringValue
        foodieItemCode = json["ItemCode"].stringValue
        foodieUserId = json["UserId"].stringValue
        foodieCreatedById = json["createdById"].stringValue
        foodieJobTypeId = json["jobTypeId"].stringValue
        foodieName = json["Name"].stringValue
        foodieDescription = json["Description"].stringValue
        foodieImage =  json["Image"].stringValue
        foodieMobile =  json["mobileNo"].stringValue
        foodieAddress =  json["address"].stringValue
        foodieCity =  json["city"].stringValue
        foodieCountry =  json["country"].stringValue
        foodieState =  json["state"].stringValue
        foodieFirstName =  json["firstName"].stringValue
        foodieLastName =  json["lastName"].stringValue
        foodieEmail =  json["Email"].stringValue
        foodieCurrentJobStatus =  json["Current_Job_Status"].stringValue
        foodieCurrentJobStatusId =  json["Current_Job_StatusId"].stringValue
        foodieFollowerCount = json["followers"].stringValue
        foodieFollowingCount = json["following"].stringValue
        foodieBannerImage = json["userBannerPath"].stringValue
    }
}


/*
 "id": 333,
 "ItemCode": "ae84d8ce-34d9-4a0b-9a81-5eaa1883e032",
 "UserId": "34",
 "createdById": 2,
 "jobTypeId": 83,
 "jobTypeName": "MacIdInfo",
 "createdByFullName": "LeFoodie",
 "publicURL": "http://35.160.251.153/app/2/Devices;MacIdInfo;333;_;SingleProduct",
 "privateToUser": "challasrinu.mca@gmail.com",
 "PackageName": "",
 "Name": "srinivasulu ",
 "password": "123456789",
 "Image": "",
 "Description": "",
 "FullName": "srinivasulu ",
 "mobileNo": "",
 "address": "",
 "city": "",
 "state": "",
 "country": "",
 "firstName": "srinivasulu",
 "lastName": "",
 "userBannerPath": "",
 "lattitude": "",
 "Email": "challasrinu.mca@gmail.com",
 "gender": "0",
 "longitude": "",
 "hrsOfOperation": [],
 "Attachments": [],
 "Additional_Details": {},
 "jobComments": [],
 "Current_Job_Status": "Active",
 "Current_Job_StatusId": 165,
 "Next_Seq_Nos": "2",
 "CreatedSubJobs": [],
 "Next_Job_Statuses": [
 {
 "Status_Id": "166",
 "SeqNo": "2",
 "Status_Name": "Inactive",
 "Sub_Jobtype_Forms": []
 }
 ],
 "Insights": [],
 "overallRating": "0.0",
 "totalReviews": "0",
 "slots": [],
 "favourites": [],
 "favouritesCount": 0,
 "malldetails": {
 "id": "2",
 "fullname": "LeFoodie",
 "email": "admin@storeongo.com"
 },
 "macIdInfodetails": ""*/
