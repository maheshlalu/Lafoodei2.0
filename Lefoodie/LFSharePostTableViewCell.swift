//
//  LFSharePostTableViewCell.swift
//  Lefoodie
//
//  Created by Manishi on 1/3/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFSharePostTableViewCell: UITableViewCell {

    @IBOutlet weak var sharedPic: UIImageView!
    @IBOutlet weak var postDescTxtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
