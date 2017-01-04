//
//  CXView.swift
//  CxTextField
//
//  Created by apple on 28/12/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit
@IBDesignable

class CXView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
//    @IBInspectable var appColor: UIColor = UIColor.white {
//        didSet {
//            self.backgroundColor = UIColor.appTheamColor()
//        }
//    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornurRadius: CGFloat = 1.0 {
        didSet {
            layer.cornerRadius = cornurRadius
            clipsToBounds = true
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        configure()
    }
    
    func setup() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 1.0
    }
    
    func configure() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornurRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    

}
