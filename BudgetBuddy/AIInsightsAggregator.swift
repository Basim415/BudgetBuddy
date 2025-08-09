//
//  AIInsightsAggregator.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/9/25.
//

import Foundation

// Conform your existing Transaction type below so the engine is independent of app model details.
protocol BBTransactionLike {
    var amount: Double { get }  // expenses < 0, income > 0
    var date: Date { get }
    var category: String { get }
}

// Compute monthly aggregates & pacing (all on-device, no raw details leave the phone).
struct SpendingAggregator {
    static func aggregate(
        transactions: [BBTransactionLike],
        month: Date = Date(),
        monthlyBudget: Double?,
        calendar: Calendar = .current
    ) -> AISpendingAggregate {
        let monthInterval = calendar.dateInterval(of: .month, for: month)!
        let thisMonth = transactions.filter { t in
            t.amount < 0 && t.date >= monthInterval.start && t.date < monthInterval.end
        }

        let totalsByCategory: [String: Double] = Dictionary(grouping: thisMonth, by: { $0.category })
            .mapValues { txs in txs.reduce(0.0) { $0 + abs($1.amount) } }

        let spentToDate: Double = thisMonth.reduce(0.0) { $0 + abs($1.amount) }

        let dayOfMonth = max(1, calendar.component(.day, from: min(Date(), monthInterval.end)))
        let daysInMonth = calendar.range(of: .day, in: .month, for: month)!.count
        let projected = (spentToDate / Double(dayOfMonth)) * Double(daysInMonth)

        return AISpendingAggregate(
            month: DateFormatter.allNumericUSA.string(from: month),
            budget: monthlyBudget,
            totalsByCategory: totalsByCategory,
            pace: .init(spentToDate: spentToDate, projected: projected)
        )
    }
}
