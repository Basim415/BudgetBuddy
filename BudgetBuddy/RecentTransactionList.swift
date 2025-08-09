//
//  RecentTransactionList.swift
//  BudgetBuddy
//

import SwiftUI

struct RecentTransactionList: View {
    let transactions: [Transaction]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent Transactions")
                    .font(.headline)
                    .bold()
                Spacer()
                NavigationLink(destination: TransactionList()) {
                    HStack(spacing: 4) {
                        Text("See All")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.appText)
                }
            }
            .padding(.top)

            let recent = Array(transactions.prefix(5))

            if recent.isEmpty {
                Text("No transactions yet. Tap + to add one.")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .padding(.vertical, 8)
            } else {
                ForEach(recent.indices, id: \.self) { index in
                    TransactionRow(transaction: recent[index])
                    if index < recent.count - 1 {
                        Divider()
                            .background(Color.appText.opacity(0.1))
                    }
                }
            }
        }
        .padding()
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
