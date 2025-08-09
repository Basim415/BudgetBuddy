//
//  AddTransactionView.swift
//  BudgetBuddy
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var merchant: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var selectedCategoryId: Int = Category.foodAndDining.id
    @State private var transactionType: String = "debit"
    @State private var isExpense: Bool = true
    @State private var showingValidationError = false

    var body: some View {
        NavigationView {
            Form {
                // MARK: Basic info
                Section(header: Text("Transaction")) {
                    TextField("Merchant name", text: $merchant)

                    HStack {
                        Text("$")
                            .foregroundStyle(.secondary)
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                    }

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                // MARK: Type
                Section(header: Text("Type")) {
                    Picker("Type", selection: $transactionType) {
                        Text("Expense").tag("debit")
                        Text("Income").tag("credit")
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: transactionType) { _, newValue in
                        isExpense = (newValue == "debit")
                    }
                }

                // MARK: Category
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategoryId) {
                        ForEach(Category.categories, id: \.id) { cat in
                            Text(cat.name).tag(cat.id)
                        }
                    }
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(merchant.trimmingCharacters(in: .whitespaces).isEmpty || amount.isEmpty)
                }
            }
            .alert("Invalid amount", isPresented: $showingValidationError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please enter a valid number for the amount.")
            }
        }
    }

    private func save() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            showingValidationError = true
            return
        }

        let cat = Category.all.first(where: { $0.id == selectedCategoryId }) ?? .foodAndDining

        let transaction = Transaction(
            date: date,
            merchant: merchant.trimmingCharacters(in: .whitespaces),
            amount: amountValue,
            transactionType: transactionType,
            categoryId: cat.id,
            category: cat.name,
            isExpense: isExpense
        )

        modelContext.insert(transaction)
        try? modelContext.save()
        dismiss()
    }
}
