//
//  AIInsightsHeuristics.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/9/25.
//

import Foundation

struct HeuristicInsightsGenerator {
    static func generate(from agg: AISpendingAggregate) -> InsightsEnvelope {
        var tips: [InsightsEnvelope.Tip] = []

        if let budget = agg.budget, budget > 0 {
            if agg.pace.projected > budget {
                let gap = agg.pace.projected - budget
                tips.append(.init(title: "Projected over budget",
                                  text: "At this pace you may exceed your \(currency(agg.pace.projected)) budget by ~\(currency(gap)). Freeze optional spend for 3 days.",
                                  priority: 1))
            } else {
                let buffer = budget - agg.pace.projected
                tips.append(.init(title: "On track — buffer \(currency(buffer))",
                                  text: "You’re pacing under budget. Pre-commit \(currency(min(buffer, budget * 0.05))) to savings or debt.",
                                  priority: 20))
            }
        }

        if let (cat, val) = agg.totalsByCategory.max(by: { $0.value < $1.value }), val > 0 {
            let total = agg.totalsByCategory.values.reduce(0, +)
            if total > 0, val / total >= 0.35 {
                tips.append(.init(title: "\(cat) is driving spend",
                                  text: "\(cat) is \(percent(val / total)) of monthly spend. Cap \(cat) at \(currency(val * 0.85)) next month.",
                                  priority: 5))
            } else {
                tips.append(.init(title: "Focus category: \(cat)",
                                  text: "You’ve spent \(currency(val)) on \(cat). Set a micro-limit for the rest of the month.",
                                  priority: 50))
            }
        }

        if tips.isEmpty {
            tips.append(.init(title: "Add more data",
                              text: "Record a few expenses to unlock personalized tips.",
                              priority: 99))
        }

        return InsightsEnvelope(tips: tips.sorted { $0.priority < $1.priority })
    }
}

func currency(_ x: Double) -> String {
    let f = NumberFormatter()
    f.numberStyle = .currency
    return f.string(from: NSNumber(value: x)) ?? "$0"
}
func percent(_ x: Double) -> String {
    let f = NumberFormatter()
    f.numberStyle = .percent
    f.maximumFractionDigits = 0
    return f.string(from: NSNumber(value: x)) ?? "0%"
}
