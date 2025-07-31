import Foundation
import SwiftUI

var transactionPreviewData = Transaction(
    id: 1,
    date: "07/18/2025",
    institution: "Chase",
    account: "Chase Visa",
    merchant: "Apple",
    amount: 11.49,                      
    type: .debit,
    categoryId: 801,
    category: "Software",
    isPending: false,
    isTransfer: false,
    isExpense: true,
    isEdited: false
)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
