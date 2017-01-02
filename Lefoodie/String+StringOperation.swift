//
//  String+StringOperation.swift
//  Lefoodie
//
//  Created by apple on 29/12/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit

extension String{
    
    func replace(target:String,withString:String) -> String {
      return  self.replacingOccurrences(of: target, with: withString, options: .literal, range: nil)
    }
    
 
// TypeName+NewFunctionality.swift.
}
