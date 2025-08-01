import Foundation
import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var body: some View {
        List {
            // MARK: Transaction Groups
            ForEach(
                transactionListVM.getTransactionByMonth()
                    .sorted { $0.key.toMonthYearDate() ?? Date() > $1.key.toMonthYearDate() ?? Date() }, // sort descending
                id: \.key
            ) { month, transactions in
                Section {
                    ForEach(transactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                } header: {
                    Text(month)
                }
            }

        }
        .listStyle(.plain)
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransactionList_Previews: PreviewProvider {
    static let transactionListVM = TransactionListViewModel()

    static var previews: some View {
        Group {
            NavigationView {
                TransactionList()
                    .environmentObject(transactionListVM)
            }

            NavigationView {
                TransactionList()
                    .environmentObject(transactionListVM)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
