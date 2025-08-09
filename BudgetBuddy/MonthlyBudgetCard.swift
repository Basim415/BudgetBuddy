import SwiftUI

struct MonthlyBudgetCard: View {
    let transactions: [Transaction]
    @AppStorage("monthlyBudget") private var monthlyBudget: Double = 1500.0

    private let trackColor = Color(UIColor.tertiarySystemFill)

    private var spent: Double {
        let currentMonth = Date().formatted(.dateTime.year().month(.wide))
        return transactions
            .filter { $0.month == currentMonth && $0.isExpense }
            .reduce(0) { $0 - $1.signedAmount }
    }

    var body: some View {
        let budget   = max(monthlyBudget, 0.01)
        let spentAbs = max(spent, 0)
        let progress = min(spentAbs / budget, 1.0)

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
                            Color.accentColor,
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
                    Text("Spent: \(spentAbs, format: .currency(code: "USD"))")
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(UIColor.separator), lineWidth: 0.5)
        )
        .shadow(radius: 1, y: 1)
    }
}
