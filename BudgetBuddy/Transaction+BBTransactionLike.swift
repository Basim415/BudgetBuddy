//
//  Transaction+BBTransactionLike.swift
//  BudgetBuddy
//

import Foundation

struct TransactionAdapter: BBTransactionLike {
    private let tx: Transaction

    init(_ tx: Transaction) { self.tx = tx }

    var amount: Double   { tx.signedAmount }
    var date: Date       { tx.date }          // was tx.dateParsed
    var category: String { tx.category }
}

extension Array where Element == Transaction {
    var asBBTransactions: [BBTransactionLike] {
        map { TransactionAdapter($0) }
    }
}
