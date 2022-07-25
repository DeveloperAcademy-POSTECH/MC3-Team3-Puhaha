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
        let timeText = formatted(.dateTime.hour(.defaultDigits(amPM: .omitted)).minute())
        let dateAndTimeFormat = NSLocalizedString("%@", comment: "Time format string")
        return String(format: dateAndTimeFormat, timeText)
    }
    
    var ampm: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        return dateFormatter.string(from: currentDate)
    }
}
