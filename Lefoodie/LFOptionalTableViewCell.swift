//
//  LFOptionalTableViewCell.swift
//  Lefoodie
//
//  Created by Rama kuppa on 14/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFOptionalTableViewCell: UITableViewCell {

    @IBAction func clickBtnAction(_ sender: UIButton) {

    }
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
