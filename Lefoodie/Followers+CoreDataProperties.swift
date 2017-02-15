//
//  Followers+CoreDataProperties.swift
//  
//
//  Created by Rambabu Mannam on 14/02/17.
//
//

import Foundation
import CoreData


extension Followers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Followers> {
        return NSFetchRequest<Followers>(entityName: "Followers");
    }

    @NSManaged public var followerId: String?
    @NSManaged public var followerName: String?
    @NSManaged public var followerEmail: String?
    @NSManaged public var followerImage: String?
    @NSManaged public var followerItemCode: String?
    @NSManaged public var followerUserId: String?
    @NSManaged public var noOfFollowers: String?
    @NSManaged public var noOfFollowings: String?
    @NSManaged public var isFollower: Bool
    @NSManaged public var isFollowing: Bool

}
