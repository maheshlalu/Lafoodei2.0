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
    
    func timeAgoSinceDate(numericDates:Bool) -> String {
        let dateStr = self
        
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMM d',' yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let dateF = dateFormatter.date(from: dateStr)
        
        // change to a readable time format and change to local time zone
        dateFormatter.timeZone = NSTimeZone.local
        let dateFinal = dateFormatter.string(from: dateF!)

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm MMM d',' yyyy"
        let date = formatter.date(from: dateFinal)

        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date!)
        let latest = (earliest == now as Date) ? date : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest! as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "Few seconds ago"
            } else {
                return "Few seconds ago"
            }
        } else if (components.second! >= 3) {
            return "Just now"
        } else {
            return "Just now"
        }
        
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

