//
//  CalendarScreen.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/5/25.
//

import SwiftUI

struct CalendarScreen: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @State private var selectedDate: Date = Date()

    private var transactionsForSelectedDate: [Transaction] {
        transactionListVM.transactions.filter {
            Calendar.current.isDate($0.dateParsed, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Expenses by Day")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding(.horizontal)

            Divider().padding(.horizontal)

            if transactionsForSelectedDate.isEmpty {
                Text("No transactions for this date.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                List(transactionsForSelectedDate) { transaction in
                    TransactionRow(transaction: transaction)
                }
                .listStyle(.plain)
            }

            Spacer()
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle("Calendar")
        .navigationBarTitleDisplayMode(.inline)
    }
}
