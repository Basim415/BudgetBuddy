//
//  TransactionList.swift
//  BudgetBuddy
//

import SwiftUI
import SwiftData

struct TransactionList: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    var body: some View {
        VStack {
            // MARK: Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search by merchant", text: $transactionListVM.searchText)
                    .foregroundColor(.primary)
                    .disableAutocorrection(true)

                if !transactionListVM.searchText.isEmpty {
                    Button {
                        transactionListVM.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.appBackground, Color.appBackground.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)

            CategoryFilterView(transactions: transactions)

            let filtered = transactionListVM.filtered(transactions)

            if filtered.isEmpty {
                Spacer()
                Text(transactionListVM.searchText.isEmpty ? "No transactions yet." : "No results found.")
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(
                        Dictionary(grouping: filtered) { $0.month }
                            .sorted { $0.key.toMonthYearDate() ?? Date() > $1.key.toMonthYearDate() ?? Date() },
                        id: \.key
                    ) { month, monthTransactions in
                        Section(header: Text(month)) {
                            ForEach(monthTransactions) { transaction in
                                NavigationLink(destination: EditTransactionView(transaction: transaction)) {
                                    TransactionRow(transaction: transaction)
                                }
                            }
                            .onDelete { indexSet in
                                deleteTransactions(monthTransactions, at: indexSet)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func deleteTransactions(_ group: [Transaction], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(group[index])
        }
    }
}
