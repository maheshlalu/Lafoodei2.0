//
//  LFNotificationTableViewCell.swift
//  Lefoodie
//
//  Created by Rama kuppa on 06/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
