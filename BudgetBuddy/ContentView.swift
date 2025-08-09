//
//  ContentView.swift
//  BudgetBuddy
//

import SwiftUI
import SwiftData
import Charts

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    // @Query fetches all transactions from SwiftData, sorted newest first.
    // The view automatically re-renders whenever the data changes.
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    @State private var showingAddTransaction = false

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: Title + Insights link
                    HStack {
                        Text("Overview")
                            .font(.title2)
                            .bold()
                        Spacer()
                        NavigationLink(destination: InsightsView()) {
                            Text("Your Insights")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }

                    MonthlyBudgetCard(transactions: transactions)

                    MonthlyExpensesBarChart(transactions: transactions)

                    MonthlySummaryView(transactions: transactions)

                    RecentTransactionList(transactions: transactions)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Add transaction button
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.appIcon, .primary)
                    }

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
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
        }
        .navigationViewStyle(.stack)
    }
}
