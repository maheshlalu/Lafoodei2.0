//
//  LFHeaderTableViewCell.swift
//  Lefoodie
//
//  Created by Rama kuppa on 30/12/16.
//  Copyright © 2016 NOVO. All rights reserved.
//

import UIKit

class LFHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var userPicImg: CXImageView!
    @IBOutlet weak var cafeNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func papulateUserinformation(feedData:LFFeedsData){
        self.lbl_Title.text = feedData.feedUserName
        self.cafeNameLbl.text = feedData.feedIDMallName
        
        if !feedData.feedUserImage.isEmpty{
        self.userPicImg.setImageWith(NSURL(string: feedData.feedUserImage) as URL!, usingActivityIndicatorStyle: .white)
        }else{
        self.userPicImg.image = UIImage(named: "placeHolder")
        }
        self.selectionStyle = .none
    }
    
}
