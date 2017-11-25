//
//  String+extensions.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//


import Foundation

extension String {
 
    ///Variable that stores localized text
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    /**
     Returns localized text
     - parameter arguments: Data
     - returns: String
     */
    func localize(with arguments: CVarArg...) -> String{
        return String(format: self.localized, arguments: arguments)
    }
    
    ///First character
    var first: String {
        return String(characters.prefix(1))
    }
    ///Last character
    var last: String {
        return String(characters.suffix(1))
    }
    ///String with only first letter update
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst()).lowercased()
    }
    
    /**
     Returns localized text
     - parameter dateString: Format text to a defined date
     - parameter dateFormat: Format to modify
     - returns: String
     */
    static func formatBy(dateString : String, dateFormat : String? = nil) -> String{
        let cal = Calendar(identifier: .gregorian)
        let date = Date(dateString: dateString)
        let dateWithZeroTime = cal.startOfDay(for: date)
        let currentDate = cal.startOfDay(for: Date())
        let formatter = DateFormatter()
        if dateFormat != nil {
            formatter.dateFormat = dateFormat
            return formatter.string(from: date)
        }else if dateWithZeroTime == currentDate{
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.dateFormat = KOnlyTime
            return formatter.string(from: date)
        }else if cal.isDateInYesterday(dateWithZeroTime){
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return kYesterdayTime + " " + formatter.string(from: date)
        }else if dateWithZeroTime < currentDate{
            formatter.dateFormat = kAmericanFormat
            return formatter.string(from: date)
        }
        return ""
    }
    
    /**
     Returns localized text by date
     - parameter dateOpenString: String containing start date
     - parameter dateCloseString: String containing close date
     - parameter dateFormat: Format to modify
     - returns: String
     */
    static func formatBy(dateOpenString : String, dateCloseString : String, dateFormat : String? = nil) -> String{
        let f1 = String.formatBy(dateString: dateOpenString,dateFormat : dateFormat)
        let f2 = String.formatBy(dateString: dateCloseString,dateFormat : dateFormat)
        return f1 + " - " + f2
    }
    
    static func appendingFormatAtributteString(_ format: String, separator: String = "%@",baseAtributte: [String: Any] = [:],HighlightedAtributte: [String: Any] = [:], _ texts: String...) -> NSMutableAttributedString{
        let formatCut :[String] = format.components(separatedBy: separator)
        let combination = NSMutableAttributedString()
        for (index, format) in formatCut.enumerated(){
            let baseText = NSMutableAttributedString(string: format, attributes: baseAtributte)
            combination.append(baseText)
            if texts.count > index{
                let HighlighteText = NSMutableAttributedString(string: texts[index], attributes: HighlightedAtributte)
                combination.append(HighlighteText)
            }
        }
        return combination
    }
}

