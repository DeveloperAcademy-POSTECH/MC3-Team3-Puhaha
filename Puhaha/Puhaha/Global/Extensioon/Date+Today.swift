//
//  Date+Today.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import Foundation

extension Date {
    var dayText: String {
        let weekText = formatted(.dateTime.weekday(.wide))
        let dateText = formatted(.dateTime.month(.abbreviated).day())
        let dateAndTimeFormat = NSLocalizedString("%@ %@", comment: "Date and Weekday format string")
        return String(format: dateAndTimeFormat, dateText, weekText)
    }
    
    var timeText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh시 mm분"
        return dateFormatter.string(from: self)
    }
    
    var ampm: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
