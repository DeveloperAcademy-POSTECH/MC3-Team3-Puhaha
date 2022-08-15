//
//  Date+Today.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import Foundation

extension Date {
    var dayText: String {
//        let weekText = formatted(.dateTime.weekday(.wide))
//        let dateText = formatted(.dateTime.month(.abbreviated).day())
//        let dateAndTimeFormat = NSLocalizedString("%@ %@", comment: "Date and Weekday format string")
//        return String(format: dateAndTimeFormat, dateText, weekText)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    
    var timeText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h시 m분"
        return dateFormatter.string(from: self)
    }
    
    var timeNumberText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hhmm"
        return dateFormatter.string(from: self)
    }
    
    var ampm: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    
    var dateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
}
