//
//  LFHomeFooterTableViewCell.swift
//  Lefoodie
//
//  Created by Rama kuppa on 30/12/16.
//  Copyright © 2016 NOVO. All rights reserved.
//

import UIKit
import RealmSwift
class LFHomeFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var alertBtn: UIButton!
    @IBOutlet weak var commentsBtn: UIButton!

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var favouritesLabel: UILabel!
    @IBOutlet weak var photoDescriptionLbl: KILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func papulatedData(feedData:LFFeedsData){
        let realm = try! Realm()
        let predicate = NSPredicate.init(format: "feedID=%@", feedData.feedID)
        let userData = realm.objects(LFHomeFeeds.self).filter(predicate)
        let data = userData.first
        let likeData = realm.objects(LFLikes.self).filter("jobId=='\(feedData.feedID)'")
        if likeData.count == 0 {
            self.likeBtn.isSelected = false
        }
        else {
            self.likeBtn.isSelected = true
        }
        print("Likes Data \(data?.feedLikesCount)")
        print("Comment Data \(data?.feedCommentsCount)")
        print("Favorate Data \(data?.feedFavaouritesCount)")
        if data?.feedLikesCount == nil || data?.feedCommentsCount == nil || data?.feedFavaouritesCount == nil {
            self.likesLabel.text = "0" + " Likes"
            self.commentsLabel.text = "0" + " Comments"
            self.favouritesLabel.text = "0" + " Favorites"
            
        }else{
            self.likesLabel.text = (data?.feedLikesCount)! + " Likes"
            self.commentsLabel.text = (data?.feedCommentsCount)! + " Comments"
            self.favouritesLabel.text = (data?.feedFavaouritesCount)! + " Favorites"
        }
        self.photoDescriptionLbl.text = data?.feedName
        
        
        self.selectionStyle = .none
    }
}
