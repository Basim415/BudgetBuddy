//
//  LaunchView.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/4/25.
//

import SwiftUI

struct LaunchView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView()
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
                        isActive = true
                    }
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(TransactionListViewModel())
    }
}
