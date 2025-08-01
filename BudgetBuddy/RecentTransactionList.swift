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
        VStack {
            HStack {
                // MARK: Header Title
                Text("Recent Transactions")
                    .bold()

                Spacer()

                // MARK: Header Link
                NavigationLink {
                    TransactionList()
                } label: {
                    HStack(spacing: 4) {
                        Text("See All")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.appText)
                }
            }
            .padding(.top)
            
            // MARK: Recent Transaction List
            ForEach(Array(transactionListVM.transactions.prefix(5).enumerated()), id: \.element.id) { index, transaction in
                TransactionRow(transaction: transaction)

                if index < 4 {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
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
                .preferredColorScheme(.dark)
                .environmentObject(transactionListVM)
        }
    }
}
