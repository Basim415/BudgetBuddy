//
//  BudgetBuddyApp.swift
//  BudgetBuddy
//

import SwiftUI
import SwiftData

@main
struct BudgetBuddyApp: App {

    @StateObject private var transactionListVM = TransactionListViewModel()
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Transaction.self)
            seedIfNeeded(context: container.mainContext)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(transactionListVM)
        }
        .modelContainer(container)
    }

    private func seedIfNeeded(context: ModelContext) {
        let existing = try? context.fetchCount(FetchDescriptor<Transaction>())
        guard (existing ?? 0) == 0 else { return }

        guard let url = Bundle.main.url(forResource: "transactions", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([TransactionJSON].self, from: data)
        else {
            print("BudgetBuddy: could not seed from transactions.json")
            return
        }

        for item in items {
            context.insert(item.toTransaction())
        }
        print("BudgetBuddy: seeded \(items.count) transactions")
    }
}
