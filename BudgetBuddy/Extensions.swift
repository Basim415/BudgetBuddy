//
//  Extensions.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 5/19/25.
//

import Foundation
import SwiftUI

extension Color {
    static let appBackground = Color("Background")
    static let appIcon = Color("Icon")
    static let appText = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}


extension ShapeStyle where Self == Color {
    static var chartBarColor: Color {
        Color("ChartBarColor", bundle: nil)
    }
}



extension DateFormatter {
    static let allNumericUSA: DateFormatter = {
        print ("Intializing DateFormatter")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    }()
}

extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.allNumericUSA.date(from: self) else { return Date() }
        return parsedDate
        
    }
}

extension String {
    func toMonthYearDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // Make sure it's in English
        formatter.dateFormat = "LLLL yyyy" // Match `.month(.wide)` = full month name
        return formatter.date(from: self)
    }
}

extension Double {
    func roundedTo2Digits() -> Double {
        return (self * 100).rounded() / 100
    }
}
