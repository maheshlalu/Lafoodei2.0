//
//  LFPlaces.swift
//  Lefoodie
//
//  Created by Rambabu Mannam on 20/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import RealmSwift

class LFPlaces: Object {
    
    dynamic var id = ""
    dynamic var category = ""
    dynamic var image = ""
    
    
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
