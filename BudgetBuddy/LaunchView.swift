//
//  LaunchView.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/4/25.
//

import SwiftUI

import SwiftUI

struct LaunchView: View {
    @State private var showLogin = false
    @State private var isAuthenticated = false
    @State private var needsPINSetup = false
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var body: some View {
        if isAuthenticated {
            ContentView()
                .environmentObject(transactionListVM)
        } else if needsPINSetup {
            PINSetupView(isAuthenticated: $isAuthenticated)
        } else if showLogin {
            LoginView(isAuthenticated: $isAuthenticated)
        } else {
            VStack(spacing: 20) {
                Image(systemName: "dollarsign.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.appIcon)

                Text("BudgetBuddy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.appText)

                Text("Track. Save. Thrive.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        if KeychainHelper.shared.getPIN() == nil {
                            needsPINSetup = true
                        } else {
                            showLogin = true
                        }
                    }
                }
            }
        }
    }
}
