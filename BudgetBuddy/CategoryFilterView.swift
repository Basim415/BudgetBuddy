//
//  CategoryFilterView.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/4/25.
//

import SwiftUI

struct CategoryFilterView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var categories: [String] {
        let all = Set(transactionListVM.transactions.map { $0.category })
        return Array(all).sorted()
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button(action: {
                    transactionListVM.selectedCategory = nil
                }) {
                    Text("All")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(transactionListVM.selectedCategory == nil ? Color.appIcon.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                }

                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        transactionListVM.selectedCategory = category
                    }) {
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
