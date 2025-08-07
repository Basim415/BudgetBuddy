//
//  RootView.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/7/25.
//

import SwiftUI

struct RootView: View {
    @State private var isAuthenticated = false
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var body: some View {
        if isAuthenticated {
            ContentView()
                .environmentObject(transactionListVM)
        } else {
            LoginView(isAuthenticated: $isAuthenticated)
        }
    }
}
