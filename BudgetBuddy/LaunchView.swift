//
//  LaunchView.swift
//  BudgetBuddy
//

import SwiftUI

struct LaunchView: View {
    @State private var showLogin = false
    @State private var isAuthenticated = false
    @State private var needsPINSetup = false

    var body: some View {
        if isAuthenticated {
            ContentView()
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
