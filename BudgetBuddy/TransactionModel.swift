//
//  TransactionModel.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 7/15/25.
//

import Foundation
struct Transaction: Identifiable {
    let id : Int
    let date: String
    let institution: String
    let account: String
    var merchant: String
    let amount: Double
    let type: TransactionType
    var categoryId: Int
    var category: String
    let isPending: Bool
    var isTransfer: Bool
    var isExpense: Bool
    var isEdited: Bool
    
    var dateParsed: Date {
        date.dateParsed()
    }
    
    var signedAmount: Double {
        return Double(type.rawValue == TransactionType.credit.rawValue ? amount : -amount)
    }
    
    enum TransactionType : String {
        case debit
        case credit
    }
    
}
