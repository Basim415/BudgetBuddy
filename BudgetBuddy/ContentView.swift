import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Title
                    Text("Overview")
                        .font(.title2)
                        .bold()

                    MonthlyBudgetCard()


                    // MARK: Chart
                    let data = transactionListVM.accumulateTransactions()
                    let totalExpenses = data.last?.1 ?? 0

                    if !data.isEmpty {
                        CardView {
                            VStack(alignment: .leading) {
                                ChartLabel(
                                    totalExpenses.formatted(.currency(code: "USD")),
                                    type: .title,
                                    format: "$%.2f"
                                )
                                LineChart()
                            }
                            .padding(.top)
                            .background(Color.appBackground)
                        }
                        .data(data)
                        .chartStyle(
                            ChartStyle(
                                backgroundColor: Color.appBackground,
                                foregroundColor: ColorGradient(Color.appIcon.opacity(0.4), Color.appIcon)
                            )
                        )
                        .frame(height: 300)
                    }
                    
                    // MARK: Monthly Summary
                    MonthlySummaryView()

                    // MARK: Recent Transaction List
                    RecentTransactionList()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: Notification Icon
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.appIcon, .primary)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let vm = TransactionListViewModel()
        vm.transactions = transactionListPreviewData
        return vm
    }()

    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(transactionListVM)
    }
}
