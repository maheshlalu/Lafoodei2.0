//
//  LFHomeFeeds.swift
//  Lefoodie
//
//  Created by Rambabu Mannam on 23/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import RealmSwift

class LFHomeFeeds: Object {
    
   dynamic var feedID = ""
   dynamic var feedItemCode = ""
   dynamic var feedCreatedDate = ""
   dynamic var feedModificationDate = ""
   dynamic var feedName = ""
   dynamic var feedImage = ""
   dynamic var feedDescription = ""
   dynamic var feedFavaouritesCount = ""
   dynamic var feedCommentsCount = ""
   dynamic var feedLikesCount = ""
   dynamic var feedIDMallID = ""
   dynamic var feedIDMallName = ""
   dynamic var feedIDMallImage = ""
   dynamic var feedUserEmail = ""
   dynamic var feedUserName = ""
   dynamic var feedUserImage = ""
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
