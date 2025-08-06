//
//  SettingsView.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/5/25.
//

import Foundation
import SwiftUI
import SwiftUICharts

struct SettingsView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                // Monthly Budget
                Section(header: Text("Monthly Budget")) {
                    HStack {
                        Text("Budget:")
                        Spacer()
                        TextField("Enter budget", value: $transactionListVM.monthlyBudget, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                }

                // Chart Type
                Section(header: Text("Chart Type")) {
                    Picker("Graph Type", selection: $transactionListVM.chartType) {
                        ForEach(ChartDisplayType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let transactionListVM = TransactionListViewModel()
    static var previews: some View {
        SettingsView()
            .environmentObject(transactionListVM)
    }
}
