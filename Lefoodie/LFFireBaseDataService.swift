//
//  LFFireBaseDataService.swift
//  Lefoodie
//
//  Created by apple on 23/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON
import RealmSwift
protocol FirebaseDelegate {
    
    func calledTheFirebaseListener(postID:String)
}

private var firebaseInstance:LFFireBaseDataService! = LFFireBaseDataService()

class LFFireBaseDataService: NSObject {
    
    lazy var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var postRef: FIRDatabaseReference = FIRDatabase.database().reference().child("POSTS")
    var commentsRef: FIRDatabaseReference!
    
    var firebaseDataDelegate : FirebaseDelegate!
    
    
    class var sharedInstance : LFFireBaseDataService {
        return firebaseInstance
    }
    
    override init() {
    }
    
    
    
    
    func addChiled(){
        //  ref = FIRDatabase.database().reference()
        //self.ref.child("users/(user)/username").setValue("Mahesh")
        
        
        //self.ref.child("POSTS/\(postID)").setValue(post)
        
        //         self.ref.child("POSTS").observe(FIRDataEventType.value, with: { (snapshot) in
        //            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
        //            // ...
        //        })
        
    }
    
   
    
    
    func updateThePostActivity(isUpdateComment:Bool,isLikeCount:Bool,isFavorites:Bool,postID:String){
        
       print(postID)
        postRef.child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if(isLikeCount){
                //increse the like count
            }else if (isUpdateComment){
                //increse the Comments count

            }else if (isFavorites){
                //increse the Favorite count

            }
            print(snapshot)
            //print(val)
          
        })
    }
    
    
    func addThePostToFirebase(postID:String){
     
        let post = ["uid": postID,
                    "CommentCount": "0",
                    "LikeCount": "0",
                    "FavouritesCount": "0"
        ] as [String : Any]
        self.postRef.child(postID).setValue(post)
        commentsRef = postRef.child(postID)

    }
    
    func updateThepostDetails(isUpdateComment:Bool,isLikeCount:Bool,isFavorites:Bool,postID:String,likeCount:String){
        var post = [String : Any]()
        post = ["uid": postID]
        if isLikeCount {
            post = ["LikeCount": likeCount]
        }
        else if isFavorites {
            //            var count = Int((feedData?.feedFavaouritesCount)!)
            //            count = count! + 1
            //            post = ["FavouritesCount":  "\(count!)"]
        }
        else if isUpdateComment {
            //            var count = Int((feedData?.feedCommentsCount)!)
            //            count = count! + 1
            //            post = ["CommentCount":  "\(count!)"]
        }
        
        self.postRef.child(postID).updateChildValues(post)
    }
    
    func addPostObserver(){
        return
        if (commentsRef != nil) {
            
            self.commentsRef.observe(.value, with: { (snapshot) -> Void in
                let postDic =  JSON(snapshot.value as? NSDictionary as Any)
                let uid = postDic["uid"].stringValue
                let realm = try! Realm()
                let predicate = NSPredicate.init(format: "feedID=%@", uid)
                let feedData = realm.objects(LFHomeFeeds.self).filter(predicate).first
                try! realm.write {
                    feedData?.feedLikesCount = postDic["LikeCount"].stringValue
                    feedData?.feedFavaouritesCount = postDic["FavouritesCount"].stringValue
                    feedData?.feedCommentsCount = postDic["CommentCount"].stringValue
                    self.firebaseDataDelegate.calledTheFirebaseListener(postID: uid)
                }
            })
            self.commentsRef.observe(.childChanged, with: { (snapshot) -> Void in
                print("childRemoved")
                
            })
            
            commentsRef.observe(.childChanged, with: { (snapshot) -> Void in
                print(snapshot)
                
            })
            commentsRef.observe(.childRemoved, with: { (snapshot) -> Void in
                
                print("childRemoved")
            })
            
            
            //            FIRDatabase.database().reference().child("POSTS").child("1425").observe(.value, with: { (snap) in
            //                if let snapDict = snap.value as? [String:AnyObject]{
            //
            //                    for each in snapDict{
            //
            //                        print(each.value)
            //
            //                    }
            //                }
            //            }, withCancel: {(err) in
            //                
            //                
            //            })
            
            
            
        }
        
    }


    //
    func addPostActivity(isUpdateComment:Bool,isLikeCount:Bool,isFavorites:Bool,postID:String){
        print(postID)
       postRef.child(postID).observe(.value, with: { (snapshot) -> Void in
        let postDic =  JSON(snapshot.value as? NSDictionary as Any)
        let uid = postDic["uid"].stringValue
        let realm = try! Realm()
        let predicate = NSPredicate.init(format: "feedID=%@", uid)
        let feedData = realm.objects(LFHomeFeeds.self).filter(predicate).first
        try! realm.write {
            feedData?.feedLikesCount = postDic["LikeCount"].stringValue
            feedData?.feedFavaouritesCount = postDic["FavouritesCount"].stringValue
            feedData?.feedCommentsCount = postDic["CommentCount"].stringValue
            self.firebaseDataDelegate.calledTheFirebaseListener(postID: uid)
        }
       })
        //print(commentsRef)
        //.child(postID)
    }
 
}



extension LFFireBaseDataService{
    
    
    

    
    func removeAllCommentsObservers(){
        commentsRef.removeAllObservers()
    }
    
}

