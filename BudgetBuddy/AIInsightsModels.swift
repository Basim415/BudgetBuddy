//
//  AIInsightsModels.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/9/25.
//
 
import Foundation
 
// Aggregated, privacy-minimized payload we send to Claude.
struct AISpendingAggregate: Codable {
    let month: String               // e.g., "August 2025"
    let budget: Double?             // optional
    let totalsByCategory: [String: Double] // e.g., {"Food": 123.45}
    let pace: Pace
 
    struct Pace: Codable {
        let spentToDate: Double     // absolute dollars spent so far this month
        let projected: Double       // simple projection to end of month
    }
}
 
// Strict, structured response from Claude (JSON mode).
struct InsightsEnvelope: Codable {
    struct Tip: Codable, Identifiable {
        var id: UUID = .init()      // auto-populated, not required from API
        let title: String
        let text: String
        let priority: Int           // lower = more important
    }
    let tips: [Tip]
}
 
