import Foundation
import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var body: some View {
        VStack {
            // MARK: Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search by merchant", text: $transactionListVM.searchText)
                    .foregroundColor(.primary)
                    .disableAutocorrection(true)

                if !transactionListVM.searchText.isEmpty {
                    Button(action: {
                        transactionListVM.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.appBackground, Color.appBackground.opacity(0.8)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            )
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)

            CategoryFilterView()

            List {
                ForEach(
                    Dictionary(grouping: transactionListVM.filteredTransactions, by: { $0.month })
                        .sorted { $0.key.toMonthYearDate() ?? Date() > $1.key.toMonthYearDate() ?? Date() },
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
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)

        .listStyle(.plain)
        .background(Color.appBackground) // 👈 Apply background color to the entire view
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
