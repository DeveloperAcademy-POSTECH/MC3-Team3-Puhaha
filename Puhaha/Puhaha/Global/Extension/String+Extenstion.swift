//
//  String+Extenstion.swift
//  Puhaha
//
//  Created by JiwKang on 2022/08/14.
//
import Foundation

extension String {
    func transferStringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
