import SwiftUI
import SwiftUICharts
import Charts

struct MonthlyExpensesBarChart: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @State private var rawSelectedDate: Date?

    // Convert transaction data to chart entries
    var monthlyData: [ViewMonth] {
        transactionListVM.monthlyTotals().compactMap { (monthString, amount) in
            if let date = monthString.toMonthYearDate() {
                return ViewMonth(date: date, viewCount: Int(abs(amount)))
            } else {
                return nil
            }
        }.sorted(by: { $0.date < $1.date })
    }

    var selectedViewMonth: ViewMonth? {
        guard let rawSelectedDate else { return nil }
        return monthlyData.first {
            Calendar.current.isDate($0.date, equalTo: rawSelectedDate, toGranularity: .month)
        }
    }

    var total: Int {
        monthlyData.reduce(0) { $0 + $1.viewCount }
    }

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Monthly Expense Breakdown")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("Total: \(total.formatted(.currency(code: "USD")))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Chart {
                    if let selectedViewMonth {
                        RuleMark(x: .value("Selected Month", selectedViewMonth.date, unit: .month))
                            .foregroundStyle(Color.appIcon.opacity(0.2))
                            .annotation(position: .top) {
                                VStack(spacing: 4) {
                                    Text(selectedViewMonth.date, format: .dateTime.month(.abbreviated))
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Text("$\(selectedViewMonth.viewCount)")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                }
                                .padding(6)
                                .background(Color.appIcon)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                    }

                    ForEach(monthlyData) { viewMonth in
                        BarMark(
                            x: .value("Month", viewMonth.date, unit: .month),
                            y: .value("Expenses", viewMonth.viewCount)
                        )
                        .foregroundStyle(
                            rawSelectedDate == nil || viewMonth.date == selectedViewMonth?.date
                            ? Color.appIcon
                            : Color.appIcon.opacity(0.3)
                        )
                    }
                }
                .frame(height: 180)
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                .chartXAxis {
                    AxisMarks(values: .stride(by: .month)) {
                        AxisValueLabel(format: .dateTime.month(.abbreviated))
                        AxisGridLine()
                    }
                }
                .chartYAxis {
                    AxisMarks {
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - ViewMonth Struct
struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let viewCount: Int
}
