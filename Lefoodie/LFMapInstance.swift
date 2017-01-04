//
//  LFMapInstance.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 03/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit
import MapKit

private var _SingletonSharedInstance:LFMapInstance! = LFMapInstance()

class LFMapInstance: NSObject {
    class var sharedInstance : LFMapInstance {
        return _SingletonSharedInstance
    }
    
    class MapView : MKMapView {
        
        required override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
         required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
        }
    }
}
