//
//  LFSocialShareTableViewCell.swift
//  Lefoodie
//
//  Created by Manishi on 1/3/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFSocialShareTableViewCell: UITableViewCell {
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var TwittrBtn: UIButton!
    @IBOutlet weak var tumblrBtn: UIButton!
    @IBOutlet weak var flickrBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
