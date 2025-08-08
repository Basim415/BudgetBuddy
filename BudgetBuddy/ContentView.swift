import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: Title + "Your Insights" Link
                    HStack {
                        Text("Overview")
                            .font(.title2)
                            .bold()

                        Spacer()

                        NavigationLink(destination: InsightsView()) {
                            Text("Your Insights")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }

                    MonthlyBudgetCard()

                    // MARK: Monthly Expense Chart (using built-in Charts framework)
                    MonthlyExpensesBarChart()

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
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CalendarScreen()) {
                        Image(systemName: "calendar")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.appIcon, .primary)
                    }

                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.appIcon, .primary)
                    }
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
