//
//  RecentTransactionList.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 7/30/25.
//

import SwiftUI

struct RecentTransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var body: some View {
        VStack(spacing: 16) {
            // MARK: Header
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

            // MARK: Recent Transaction Rows
            let recentTransactions = Array(transactionListVM.transactions.prefix(5))

            ForEach(recentTransactions.indices, id: \.self) { index in
                TransactionRow(transaction: recentTransactions[index])

                if index < recentTransactions.count - 1 {
                    Divider()
                        .background(Color.appText.opacity(0.1))
                }
            }
        }
        .padding()
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct RecentTransactionList_Preview: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let vm = TransactionListViewModel()
        vm.transactions = transactionListPreviewData
        return vm
    }()

    static var previews: some View {
        Group {
            RecentTransactionList()
                .environmentObject(transactionListVM)

            RecentTransactionList()
                .environmentObject(transactionListVM)
                .preferredColorScheme(.dark)
        }
    }
}
