//
//  Date+extensions.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation

extension Date{
    /**
     New builder type for date
     - parameter dateString: Date in text format
     - parameter dateFormat: date format, default format kFullTime1
     */
    init(dateString: String, dateFormat : String = kFullTime1) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = dateFormat
        var date : Date
        
        if let dateWithFormat = dateStringFormatter.date(from: dateString){
            date = dateWithFormat
        }else{
            dateStringFormatter.dateFormat = kFullTimeUTC1
            dateStringFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let dateWithFormat = dateStringFormatter.date(from: dateString){
                date = dateWithFormat
            }else{
                dateStringFormatter.dateFormat = kFullTimeUTC2
                dateStringFormatter.timeZone = TimeZone(abbreviation: "UTC")
                
                if let dateWithFormat = dateStringFormatter.date(from: dateString){
                    date = dateWithFormat
                }else{
                    dateStringFormatter.dateFormat = kFullTimeUTC3
                    dateStringFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    if let dateFormat = dateStringFormatter.date(from: dateString) {
                        date = dateFormat
                    } else {
                        date = Date()
                    }
                }
            }
        }
        
        self.init(timeInterval: 0, since: date)
    }
    
    /**
     Adds a number of days to a date
     - parameter days: number of days
     - returns: Date
     */
    func dateAddingDays(days: Int) -> Date{
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    /**
     Format a date
     - parameter format: Date in text format
     - returns: String
     */
    func formatDate(format: String = kSimpleTime) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
