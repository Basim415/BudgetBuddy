//
//  CategoryFilterView.swift
//  BudgetBuddy
//

import SwiftUI

struct CategoryFilterView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    let transactions: [Transaction]

    var categories: [String] {
        Array(Set(transactions.map { $0.category })).sorted()
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button {
                    transactionListVM.selectedCategory = nil
                } label: {
                    Text("All")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(transactionListVM.selectedCategory == nil ? Color.appIcon.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                }

                ForEach(categories, id: \.self) { category in
                    Button {
                        transactionListVM.selectedCategory = category
                    } label: {
                        Text(category)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(transactionListVM.selectedCategory == category ? Color.appIcon.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
