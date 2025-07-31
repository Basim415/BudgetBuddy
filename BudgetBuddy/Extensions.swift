//
//  Extensions.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 5/19/25.
//

import Foundation
import SwiftUI

extension Color {
    static let appBackground = Color("AppBackground")
    static let appIcon = Color("AppIcon")
    static let appText = Color("AppText")
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
