//
//  SettingsView.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/5/25.
//

//  Adds an "AI Settings" section so the user can paste in their
//  Anthropic API key. It is stored securely in the Keychain.
//

import Foundation
import SwiftUI
import SwiftUICharts

struct SettingsView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @Environment(\.dismiss) var dismiss

    // API key state
    @State private var apiKeyInput: String = ""
    @State private var isKeyVisible: Bool = false
    @State private var keySaved: Bool = false

    private var maskedKey: String {
        let stored = KeychainHelper.shared.getAPIKey() ?? ""
        guard stored.count > 8 else { return stored.isEmpty ? "Not set" : "••••••••" }
        return String(stored.prefix(4)) + "••••••••" + String(stored.suffix(4))
    }

    var body: some View {
        NavigationView {
            Form {
                // MARK: Monthly Budget
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

                // MARK: Chart Type
                Section(header: Text("Chart Type")) {
                    Picker("Graph Type", selection: $transactionListVM.chartType) {
                        ForEach(ChartDisplayType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // MARK: AI Settings
                Section(
                    header: Text("AI Insights"),
                    footer: Text("Your key is stored securely in the Keychain and never shared. Only aggregated category totals are sent to Claude.")
                ) {
                    // Show current status
                    HStack {
                        Text("API Key")
                        Spacer()
                        Text(maskedKey)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }

                    // Input field
                    HStack {
                        Group {
                            if isKeyVisible {
                                TextField("sk-ant-…", text: $apiKeyInput)
                            } else {
                                SecureField("Paste API key here", text: $apiKeyInput)
                            }
                        }
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                        Button {
                            isKeyVisible.toggle()
                        } label: {
                            Image(systemName: isKeyVisible ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }

                    // Save / Delete row
                    HStack {
                        Button("Save Key") {
                            let trimmed = apiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            KeychainHelper.shared.saveAPIKey(trimmed)
                            apiKeyInput = ""
                            keySaved = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { keySaved = false }
                        }
                        .disabled(apiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                        Spacer()

                        if keySaved {
                            Label("Saved", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                        }

                        Button("Remove", role: .destructive) {
                            KeychainHelper.shared.deleteAPIKey()
                            apiKeyInput = ""
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
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
