//
//  NSDate+date.swift
//  Lefoodie
//
//  Created by apple on 30/12/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit

extension NSDate {
//    var calendar: NSCalendar {
//        return NSCalendar(calendarIdentifier: NSCalendar.init(calendarIdentifier: .gregorian))
//        
//        //NSCalendar(identifier: NSCalendar.Identifier(rawValue: NSCalendarIdentifierGregorian))!
//    }
    
  /*  func after(value: Int, calendarUnit:NSCalendar.Unit) -> NSDate{
        return calendar.dateByAddingUnit(calendarUnit, value: value, toDate: self as Date, options:)!
    }
    
    func minus(date: NSDate) -> NSDateComponents{
        
        calendar.components(<#T##unitFlags: NSCalendar.Unit##NSCalendar.Unit#>, from: self, to: date, options: NSCalendar.Options)
        
        return calendar.components(NSCalendar.Unit.MinuteCalendarUnit, fromDate: self, toDate: date, options: NSCalendar.Options(0))
    }*/
    
    func equalsTo(date: NSDate) -> Bool {
        return self.compare(date as Date) == ComparisonResult.orderedSame
    }
    
    
    func greaterThan(date: NSDate) -> Bool {
        return self.compare(date as Date) == ComparisonResult.orderedDescending
    }
    
    func lessThan(date: NSDate) -> Bool {
        return self.compare(date as Date) == ComparisonResult.orderedAscending
    }
    
    
    class func parse(dateString: String, format: String = "yyyy-MM-dd HH:mm:ss") -> NSDate{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: dateString)! as NSDate
    }
    
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
    
}
