import SwiftUI

struct MonthlyBudgetCard: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    private let trackColor = Color(UIColor.tertiarySystemFill) // adaptive gray

    var body: some View {
        let budget = max(transactionListVM.monthlyBudget, 0.01) // avoid divide-by-zero
        let spent  = max(transactionListVM.currentMonthExpenseTotal, 0)
        let progress = min(spent / budget, 1.0)

        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Budget")
                .font(.headline)
                .foregroundStyle(.secondary)

            HStack(alignment: .center, spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(trackColor, lineWidth: 10)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color.accentColor, // or Color.appIcon if you have it
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut, value: progress)

                    Text("\(Int(progress * 100))%")
                        .font(.caption).bold()
                        .foregroundStyle(.primary)
                }
                .frame(width: 60, height: 60)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Spent: \(spent, format: .currency(code: "USD"))")
                        .font(.subheadline)
                        .foregroundStyle(.primary)

                    Text("Budget: \(budget, format: .currency(code: "USD"))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading) // <-- make card fill width
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(UIColor.separator), lineWidth: 0.5)
        )
        .shadow(radius: 1, y: 1)
        // .padding(.horizontal)  // <-- remove to match old full-width behavior
    }
}
