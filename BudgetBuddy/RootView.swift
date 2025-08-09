//
//  RootView.swift
//  BudgetBuddy
//

import SwiftUI

struct RootView: View {
    @State private var isAuthenticated = false

    var body: some View {
        if isAuthenticated {
            ContentView()
        } else {
            LoginView(isAuthenticated: $isAuthenticated)
        }
    }
}
