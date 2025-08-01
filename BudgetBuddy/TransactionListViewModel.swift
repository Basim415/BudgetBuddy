//
//  TransactionListViewModel.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 7/30/25.
//

import Foundation
import Combine
import Collections


typealias TransactionGroup = [String: [Transaction]]

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []

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
}

