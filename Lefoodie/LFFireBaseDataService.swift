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

private var firebaseInstance:LFFireBaseDataService! = LFFireBaseDataService()

class LFFireBaseDataService: NSObject {

    var ref: FIRDatabaseReference!
    
    

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
    
    
    
    
    func addPostActivity(isUpdateComment:Bool,isLikeCount:Bool,isFavorites:Bool,postID:String){
        
        ref = FIRDatabase.database().reference()
        
        let post = ["uid": postID,
                    "CommentCount": "10",
                    "LikeCount": "2",
                     "FavouritesCount": "2"
                    ]
        self.ref.child("POSTS/\(postID)").setValue(post)
        
        
//        ref.child("POSTS")
//            .child((FIRAuth.auth()?.currentUser?.uid)!)
//            //.queryOrdered(byChild: "fromId")
//            //.queryEqual(toValue: "theUidThatYou'reLookingFor")
//            .observeSingleEvent(of: .childAdded, with: { (snapshot) in
//                print("\(snapshot.key)")
//                print("\(snapshot)")
//
//            })
        
        
        ref.child(byAppendingPath: "POSTS")
            .child(byAppendingPath: postID)
            .observeSingleEvent(of: .childAdded, with: { snapshot in
                
                print("\(snapshot)")
                
                
                
            })
        
        
  
       // let key = ref.child("POSTS").queryOrdered(byChild: postID)

        //"LikeCount": "2",
        //"FavouritesCount": "2"
       /* let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
          //  let user = User.init(username: username)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }*/
        
    }
    
}
