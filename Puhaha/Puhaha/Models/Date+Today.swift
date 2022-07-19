//
//  Date+Today.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import Foundation

extension Date {
    var dayAndTimeText: String {
        let weekText = formatted(.dateTime.weekday(.wide))
        let dateText = formatted(.dateTime.month(.abbreviated).day())
        let dateAndTimeFormat = NSLocalizedString("%@ %@", comment: "Date and Weekday format string")
        return String(format: dateAndTimeFormat, dateText, weekText)
    }
}
