//
//  LFPlacesSearchTableViewCell.swift
//  Lefoodie
//
//  Created by Rambabu Mannam on 21/03/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import Cosmos

class LFPlacesSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeName: UILabel!
@IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
