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
    
   static func generateBoundaryString() -> String
    {
        return "\(UUID().uuidString)"
    }
    
    
   static func genarateJsonString(dataDic:NSDictionary)->String{
        let listArray : NSMutableArray = NSMutableArray()
        listArray.add(dataDic)
        let formDict :NSMutableDictionary = NSMutableDictionary()
        formDict.setObject(listArray, forKey: "list" as NSCopying)
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: formDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
        return jsonStringFormat!
    }
    
 
// TypeName+NewFunctionality.swift.
}


extension NSString{
    func convertStringToDictionary() -> NSDictionary {
        var jsonDict : NSDictionary = NSDictionary()
        let data = self.data(using: String.Encoding.utf8.rawValue)
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary            // CXDBSettings.sharedInstance.saveAllMallsInDB((jsonData.valueForKey("orgs") as? NSArray)!)
        } catch {
            //print("Error in parsing")
        }
        return jsonDict
    }
}

