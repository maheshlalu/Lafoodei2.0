//
//  LFCommentTableViewCell.swift
//  Lefoodie
//
//  Created by Manishi on 2/23/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentImg: CXImageView!
    @IBOutlet weak var commentTxt: UILabel!
    @IBOutlet weak var commentTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
