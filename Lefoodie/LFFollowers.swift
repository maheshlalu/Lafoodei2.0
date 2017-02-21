//
//  LFFollowers.swift
//  Lefoodie
//
//  Created by Rambabu Mannam on 20/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import RealmSwift

class LFFollowers: Object {
    
    dynamic var followerEmail = ""
    dynamic var followerId = ""
    dynamic var followerImage = ""
    dynamic var followerItemCode = ""
    dynamic var followerName = ""
    dynamic var followerUserId = ""
    dynamic var isFollower = false
    dynamic var isFollowing = false
    dynamic var noOfFollowers = ""
    dynamic var noOfFollowings = ""
    
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
