//
//  LFUserPhotos.swift
//  Lefoodie
//
//  Created by apple on 16/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import RealmSwift

class LFUserPhotos: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic  var userId = ""
    
    
    dynamic var  feedID = ""
    dynamic var feedItemCode = ""
    dynamic var feedCreatedDate = ""
    dynamic var feedModificationDate = ""
    dynamic var feedName = ""
    dynamic var feedImage = ""
    dynamic var feedDescription = ""
    dynamic var feedFavaouritesCount = ""
    dynamic var feedIDMallID = ""
    dynamic var feedIDMallName = ""
    dynamic var feedIDMallImage = ""
    dynamic var feedUserEmail = ""
    dynamic var feedUserName = ""
    dynamic var feedUserImage = ""
    //dynamic var dynamic var value: LFFeedsData?

}
