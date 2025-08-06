//
//  TransactionListViewModel.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 7/30/25.
//

import Foundation
import Combine
import Collections
import SwiftUI
import SwiftUICharts

enum ChartDisplayType: String, CaseIterable {
    case line = "Line Chart"
    case bar = "Bar Chart"
}

typealias TransactionGroup = [String: [Transaction]]
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject {
    @Published var chartType: ChartDisplayType = .line
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    @AppStorage("monthlyBudget") var monthlyBudget: Double = 1500.0
    @Published var transactions: [Transaction] = []
    
    var filteredTransactions: [Transaction] {
        transactions.filter { transaction in
            // Filter by category if selected
            let categoryMatch = selectedCategory == nil || transaction.category == selectedCategory
            // Filter by search text if entered
            let searchMatch = searchText.isEmpty || transaction.merchant.lowercased().contains(searchText.lowercased())
            return categoryMatch && searchMatch
        }
    }
    
    var currentMonthExpenseTotal: Double {
        let currentMonth = Date().formatted(.dateTime.year().month(.wide))
        return transactions
            .filter { $0.month == currentMonth && $0.isExpense }
            .reduce(0) { $0 - $1.signedAmount }
    }

    init() {
        getTransactions()
    }

    func getTransactions() {
        guard let url = Bundle.main.url(forResource: "transactions", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let transactions = try? JSONDecoder().decode([Transaction].self, from: data) else {
            print("Failed to load transactions.")
            return
        }

        self.transactions = transactions
    }

    func getTransactionByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }

        let groupedTransactions = Dictionary(grouping: transactions) { $0.month }
        return groupedTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        guard !transactions.isEmpty else { return [] }

        let calendar = Calendar.current
        let groupedTransactions = Dictionary(grouping: transactions.filter { $0.isExpense }) {
            calendar.startOfDay(for: $0.dateParsed)
        }

        let sortedDates = groupedTransactions.keys.sorted()
        var sum: Double = .zero
        var cumulativeSum: TransactionPrefixSum = []

        for date in sortedDates {
            let dailyTotal = groupedTransactions[date]?.reduce(0) { $0 - $1.signedAmount } ?? 0
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date.formatted(date: .abbreviated, time: .omitted), sum))
        }

        return cumulativeSum
    }
    
    func monthlyTotals() -> [(String, Double)] {
        _ = Calendar.current
        let grouped = Dictionary(grouping: transactions.filter { $0.isExpense }) {
            $0.dateParsed.formatted(.dateTime.year().month())
        }

        let sortedKeys = grouped.keys.sorted {
            $0.toMonthYearDate() ?? Date() < $1.toMonthYearDate() ?? Date()
        }

        return sortedKeys.map { key in
            let total = grouped[key]?.reduce(0.0) { $0 - $1.signedAmount } ?? 0
            return (key, total.roundedTo2Digits())
        }
    }

   
}

