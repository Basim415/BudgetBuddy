//
//  MonthlySummaryView.swift
//  BudgetBuddy
//

import SwiftUI

struct MonthlySummaryView: View {
    let transactions: [Transaction]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Summary")
                .font(.title3)
                .bold()
                .padding(.horizontal)

            ForEach(sortedMonthlySums, id: \.key) { month, total in
                HStack {
                    Text(month)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(total, format: .currency(code: "USD"))
                        .bold()
                        .foregroundColor(.appText)
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.primary.opacity(0.1), radius: 6, x: 0, y: 3)
    }

    private var sortedMonthlySums: [(key: String, value: Double)] {
        let grouped = Dictionary(grouping: transactions.filter { $0.isExpense }) { $0.month }
        let totals  = grouped.mapValues { txs in
            txs.reduce(0) { $0 - $1.signedAmount }
        }
        return totals.sorted { $0.key.toMonthYearDate() ?? Date() > $1.key.toMonthYearDate() ?? Date() }
    }
}
