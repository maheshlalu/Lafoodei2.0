//
//  LFEditTableViewCell.swift
//  Lefoodie
//
//  Created by Rama kuppa on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFEditTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var infoTextfield: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
