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
        AdaptiveCard {
            VStack(alignment: .leading, spacing: 16) { // more spacing
                Text("Monthly Expense Breakdown")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("Total: \(total.formatted(.currency(code: "USD")))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Chart {
                    if let selectedViewMonth {
                        RuleMark(x: .value("Selected Month", selectedViewMonth.date, unit: .month))
                            .foregroundStyle(Color.appIcon.opacity(0.25))
                            .annotation(position: .top) {
                                VStack(spacing: 4) {
                                    Text(selectedViewMonth.date, format: .dateTime.month(.abbreviated))
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                    Text("$\(selectedViewMonth.viewCount)")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
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
                .frame(height: 200) // slightly taller chart
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))

                // Larger & brighter axis labels for readability
                .chartXAxis {
                    AxisMarks(values: .stride(by: .month)) { _ in
                        AxisGridLine().foregroundStyle(.secondary.opacity(0.25))
                        AxisTick().foregroundStyle(.secondary.opacity(0.6))
                        AxisValueLabel(format: .dateTime.month(.abbreviated))
                            .foregroundStyle(.primary.opacity(0.85))
                            .font(.callout) // bigger
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine().foregroundStyle(.secondary.opacity(0.25))
                        AxisTick().foregroundStyle(.secondary.opacity(0.6))
                        AxisValueLabel()
                            .foregroundStyle(.primary.opacity(0.85))
                            .font(.callout) // bigger
                    }
                }

                // Let the card supply the background; keep the plot area clear
                .chartPlotStyle { plot in
                    plot.background(.clear)
                }
            }
            .padding(.top, 20)        // more breathing room
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .frame(minHeight: 260)     // overall bigger card
        }
    }
}

// MARK: - Adaptive Rounded Card (Light/Dark safe, matches Monthly Summary card)
struct AdaptiveCard<Content: View>: View {
    private let content: Content
    private let cornerRadius: CGFloat = 16

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color(UIColor.secondarySystemBackground)) // lighter, matching shade
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 8, y: 2)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

// MARK: - ViewMonth Struct
struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let viewCount: Int
}
