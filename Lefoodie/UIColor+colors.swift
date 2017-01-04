//
//  UIColor+colors.swift
//  Lefoodie
//
//  Created by apple on 30/12/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit

extension UIColor{

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /*Application TheamColr*/
   open class  func appTheamColor() -> UIColor{
        
        return UIColor(
            red: 225.0 / 255.0,
            green: 205.0 / 255.0,
            blue:  0.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //RGB(225,205,0)
}
