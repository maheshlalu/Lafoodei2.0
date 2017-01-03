//
//  CXAlbumCollectionViewCell.swift
//  Lefoodie
//
//  Created by Manishi on 1/2/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class CXAlbumCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        
        didSet {
            
            self.imageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSelected = false
    }
    
    override var isSelected : Bool {
        didSet {
            self.layer.borderColor = isSelected ? CXTintColor.cgColor : UIColor.clear.cgColor
            self.layer.borderWidth = isSelected ? 2 : 0
        }
    }

}
