//
//  LFFoodies.swift
//  Lefoodie
//
//  Created by Rambabu Mannam on 23/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import RealmSwift

class LFFoodies: Object {
    
   dynamic var foodieId = ""
   dynamic var foodieItemCode = ""
   dynamic var foodieUserId = ""
   dynamic var foodieCreatedById = ""
   dynamic var foodieJobTypeId = ""
   dynamic var foodieName = ""
   dynamic var foodieDescription = ""
   dynamic var foodieImage = ""
   dynamic var foodieMobile = ""
   dynamic var foodieAddress = ""
   dynamic var foodieCity = ""
   dynamic var foodieCountry = ""
   dynamic var foodieState = ""
   dynamic var foodieFirstName = ""
   dynamic var foodieLastName = ""
   dynamic var foodieEmail = ""
   dynamic var foodieCurrentJobStatus = ""
   dynamic var foodieCurrentJobStatusId = ""
   dynamic var foodieFollowingCount = ""
   dynamic var foodieFollowerCount = ""
   dynamic var jSON = ""
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
