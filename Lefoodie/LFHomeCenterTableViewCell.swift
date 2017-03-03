//
//  LFHomeCenterTableViewCell.swift
//  Lefoodie
//
//  Created by Rama kuppa on 30/12/16.
//  Copyright © 2016 NOVO. All rights reserved.
//

import UIKit

class LFHomeCenterTableViewCell: UITableViewCell {

    @IBOutlet weak var ImgView_Logo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func papulateImageData(feedData:LFFeedsData){
        let img_Url_Str = feedData.feedImage
        let img_Url = NSURL(string: img_Url_Str )
        self.imageView?.contentMode = .scaleAspectFit
        //self.ImgView_Logo.setImageWith(img_Url as URL!, usingActivityIndicatorStyle: .white)
        self.ImgView_Logo.setImageWith(img_Url as URL!, usingActivityIndicatorStyle: .white)
        
        print(self.ImgView_Logo.image?.size.width)
        print(self.ImgView_Logo.image?.size.width)


        //http://www.artifexterra.com/media/screenshots/artifex_terra_10012012_141437090.png
        self.selectionStyle = .none
    }

}
