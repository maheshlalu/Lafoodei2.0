//
//  RestaurantsLocations.swift
//  Lefoodie
//
//  Created by Manishi on 3/2/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class RestaurantsLocation {
    
    var RLocationId : String
    var RLocationItemCode : String
    var RLocationName : String
    var RLocationAddress : String
    var RLocationDescription: String
    var RLocationJSON : JSON
    
    //MARK: Initialization
    init(locationJson: JSON) {
        RLocationId = locationJson["id"].stringValue
        RLocationItemCode = locationJson["ItemCode"].stringValue
        RLocationName = locationJson["Name"].stringValue
        RLocationAddress = locationJson["Address"].stringValue
        RLocationDescription = locationJson["Description"].stringValue
        RLocationJSON = locationJson
    }
}
