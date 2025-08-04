import SwiftUI
import SwiftUICharts

struct MonthlyBudgetCard: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var body: some View {
        let budget = transactionListVM.monthlyBudget
        let spent = transactionListVM.currentMonthExpenseTotal
        let progress = min(spent / budget, 1.0)

        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Monthly Budget")
                    .font(.headline)
                    .foregroundColor(.secondary)

                HStack(alignment: .center, spacing: 16) {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color.appIcon, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut, value: progress)
                        Text("\(Int(progress * 100))%")
                            .font(.caption)
                            .bold()
                    }
                    .frame(width: 60, height: 60)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Spent: \(spent, format: .currency(code: "USD"))")
                            .font(.subheadline)
                        Text("Budget: \(budget, format: .currency(code: "USD"))")
                            .font(.subheadline)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }
}
