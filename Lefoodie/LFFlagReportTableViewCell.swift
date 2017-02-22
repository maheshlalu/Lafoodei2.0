//
//  LFFlagReportTableViewCell.swift
//  Lefoodie
//
//  Created by Rama kuppa on 22/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFFlagReportTableViewCell: UITableViewCell {

    @IBOutlet weak var reportingBtn: UIButton!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func reportingBtnAction(_ sender: UIButton) {
    }
    
    
    
}
