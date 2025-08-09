//
//  TransactionListViewModel.swift
//  BudgetBuddy
//

import Foundation
import SwiftUI
import Collections

enum ChartDisplayType: String, CaseIterable {
    case line = "Line Chart"
    case bar  = "Bar Chart"
}

typealias TransactionGroup     = [String: [Transaction]]
typealias TransactionPrefixSum = [(String, Double)]

// The ViewModel is now a lightweight helper for computed values and UI state.
// It no longer owns or loads transactions — SwiftData views use @Query for that.
final class TransactionListViewModel: ObservableObject {
    @Published var chartType: ChartDisplayType = .line
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    @AppStorage("monthlyBudget") var monthlyBudget: Double = 1500.0

    // MARK: - Filtering

    func filtered(_ transactions: [Transaction]) -> [Transaction] {
        transactions.filter { t in
            let categoryMatch = selectedCategory == nil || t.category == selectedCategory
            let searchMatch   = searchText.isEmpty || t.merchant.lowercased().contains(searchText.lowercased())
            return categoryMatch && searchMatch
        }
    }

    // MARK: - Aggregation helpers
    // These take a [Transaction] passed in from the view (via @Query),
    // so there's no stored array here anymore.

    func currentMonthTotal(_ transactions: [Transaction]) -> Double {
        let currentMonth = Date().formatted(.dateTime.year().month(.wide))
        return transactions
            .filter { $0.month == currentMonth && $0.isExpense }
            .reduce(0) { $0 - $1.signedAmount }
    }

    func groupByMonth(_ transactions: [Transaction]) -> TransactionGroup {
        Dictionary(grouping: transactions) { $0.month }
    }

    func accumulateTransactions(_ transactions: [Transaction]) -> TransactionPrefixSum {
        guard !transactions.isEmpty else { return [] }

        let calendar = Calendar.current
        let grouped  = Dictionary(grouping: transactions.filter { $0.isExpense }) {
            calendar.startOfDay(for: $0.date)
        }

        let sortedDates = grouped.keys.sorted()
        var sum: Double = .zero
        var result: TransactionPrefixSum = []

        for date in sortedDates {
            let dailyTotal = grouped[date]?.reduce(0) { $0 - $1.signedAmount } ?? 0
            sum += dailyTotal
            sum  = sum.roundedTo2Digits()
            result.append((date.formatted(date: .abbreviated, time: .omitted), sum))
        }

        return result
    }

    func monthlyTotals(_ transactions: [Transaction]) -> [(String, Double)] {
        let grouped = Dictionary(grouping: transactions.filter { $0.isExpense }) {
            $0.date.formatted(.dateTime.year().month())
        }

        return grouped.keys
            .sorted { $0.toMonthYearDate() ?? Date() < $1.toMonthYearDate() ?? Date() }
            .map { key in
                let total = grouped[key]?.reduce(0.0) { $0 - $1.signedAmount } ?? 0
                return (key, total.roundedTo2Digits())
            }
    }
}
