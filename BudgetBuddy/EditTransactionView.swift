//
//  EditTransactionView.swift
//  BudgetBuddy
//

import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var transaction: Transaction

    @State private var merchant: String
    @State private var amount: String
    @State private var date: Date
    @State private var transactionType: String
    @State private var selectedCategoryId: Int
    @State private var isExpense: Bool
    @State private var showingDeleteConfirmation = false
    @State private var showingValidationError = false

    init(transaction: Transaction) {
        self.transaction = transaction
        _merchant           = State(initialValue: transaction.merchant)
        _amount             = State(initialValue: String(transaction.amount))
        _date               = State(initialValue: transaction.date)
        _transactionType    = State(initialValue: transaction.transactionType)
        _selectedCategoryId = State(initialValue: transaction.categoryId)
        _isExpense          = State(initialValue: transaction.isExpense)
    }

    private var selectedCategory: Category {
        Category.all.first(where: { $0.id == selectedCategoryId }) ?? .foodAndDining
    }

    var body: some View {
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

            // MARK: Delete
            Section {
                Button("Delete Transaction", role: .destructive) {
                    showingDeleteConfirmation = true
                }
            }
        }
        .navigationTitle("Edit Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(merchant.trimmingCharacters(in: .whitespaces).isEmpty || amount.isEmpty)
            }
        }
        .alert("Delete transaction?", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) { delete() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This cannot be undone.")
        }
        .alert("Invalid amount", isPresented: $showingValidationError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please enter a valid number for the amount.")
        }
    }

    private func save() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            showingValidationError = true
            return
        }

        transaction.merchant        = merchant.trimmingCharacters(in: .whitespaces)
        transaction.amount          = amountValue
        transaction.date            = date
        transaction.transactionType = transactionType
        transaction.categoryId      = selectedCategoryId
        transaction.category        = selectedCategory.name
        transaction.isExpense       = isExpense
        transaction.isEdited        = true

        try? modelContext.save()
        dismiss()
    }

    private func delete() {
        modelContext.delete(transaction)
        try? modelContext.save()
        dismiss()
    }
}
