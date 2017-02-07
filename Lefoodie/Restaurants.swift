//
//  Restaurants.swift
//  Lefoodie
//
//  Created by apple on 07/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import SwiftyJSON

 class  Restaurants{
    
    var restaurantID : String
    var restaurantName : String
    var totalDic : JSON
    
    //MARK: Initialization
    init(json: JSON) {
        restaurantID = json["id"].stringValue
        restaurantName = json["name"].stringValue
        totalDic =  json
    }
    
}



/*
 id: "12",
 name: "Pearl Sushi Lover",
 email: "pearlsushilover_sog@ongo.com",
 businessType: [ ],
 currencyType: "",
 languageCode: "en",
 languageName: "English",
 logo: "http://35.160.251.153:8085/coin/files/12/users/profilePics/12_1485769420279.jpg",
 mainCategory: "",
 publicURL: "http://35.160.251.153/application/m?orgid=12",
 promotionURL: "http://35.160.251.153/m/12/webapp",
 Cover_Image: "http://35.160.251.153:8085/coin/files/users/images/12_1485772815715.PNG",
 primaryColor: "",
 secondaryColor: "",
 address: {
 location: "Gilroy Village Shopping Center,, 340 E 10th St, Gilroy, CA 95020, United States",
 city: "Gilroy",
 state: "California",
 id: 6
 },
 latitude: "37.0012012",
 longitude: "-121.5617915",
 defaultStoreId: 97,
 defultStoreItemCode: "ACNP_31",
 Facebookinfo: "",
 hrsOfOperation: [ ],
 gallery: [ ],
 offersCount: "0",
 storesCount: "0
 */
