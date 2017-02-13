//
//  LFFoodiesTableViewCell.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 04/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit

class LFFoodiesTableViewCell: UITableViewCell {
    @IBOutlet weak var foodieImageView: UIImageView!
    @IBOutlet weak var foodieName: UILabel!
    @IBOutlet weak var foodieFollowLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
