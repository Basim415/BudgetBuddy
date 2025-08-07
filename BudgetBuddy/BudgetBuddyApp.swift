//
//  BudgetBuddyApp.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 5/19/25.
//

import SwiftUI

@main
struct BudgetBuddyApp: App {
    @StateObject private var transactionListVM = TransactionListViewModel()

    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(transactionListVM)
        }
    }
}
