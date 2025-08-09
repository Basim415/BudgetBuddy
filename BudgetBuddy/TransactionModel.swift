//
//  TransactionModel.swift
//  BudgetBuddy
//

import Foundation
import SwiftData
import SwiftUIFontIcon

// MARK: - Transaction

// Changed from struct to @Model class for SwiftData persistence.
// Key differences from the old version:
//   - `id` is now a UUID (SwiftData prefers this over Int)
//   - `date` is now a real Date instead of a String (no more dateParsed needed)
//   - `transactionType` replaces `type` to avoid conflicting with a SwiftData reserved word
//   - Custom Decodable init is removed — we add a separate import helper below
@Model
final class Transaction {
    var id: UUID
    var date: Date
    var institution: String
    var account: String
    var merchant: String
    var amount: Double
    var transactionType: String      // "debit" or "credit"
    var categoryId: Int
    var category: String
    var isPending: Bool
    var isTransfer: Bool
    var isExpense: Bool
    var isEdited: Bool

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        institution: String = "",
        account: String = "",
        merchant: String,
        amount: Double,
        transactionType: String,
        categoryId: Int,
        category: String,
        isPending: Bool = false,
        isTransfer: Bool = false,
        isExpense: Bool = true,
        isEdited: Bool = false
    ) {
        self.id = id
        self.date = date
        self.institution = institution
        self.account = account
        self.merchant = merchant
        self.amount = amount
        self.transactionType = transactionType
        self.categoryId = categoryId
        self.category = category
        self.isPending = isPending
        self.isTransfer = isTransfer
        self.isExpense = isExpense
        self.isEdited = isEdited
    }
}

// MARK: - Computed properties

extension Transaction {
    var icon: FontAwesomeCode {
        Category.all.first(where: { $0.id == categoryId })?.icon ?? .question
    }

    var signedAmount: Double {
        transactionType == "credit" ? amount : -amount
    }

    var month: String {
        date.formatted(.dateTime.year().month(.wide))
    }
}

// MARK: - JSON import helper
// Used once at first launch to seed SwiftData from your existing transactions.json.

struct TransactionJSON: Decodable {
    let id: Int
    let date: String
    let institution: String
    let account: String
    let merchant: String
    let amount: Double
    let type: String
    let categoryId: Int
    let category: String
    let isPending: Bool
    let isTransfer: Bool
    let isExpense: Bool
    let isEdited: Bool

    func toTransaction() -> Transaction {
        Transaction(
            date: date.dateParsed(),
            institution: institution,
            account: account,
            merchant: merchant,
            amount: amount,
            transactionType: type,
            categoryId: categoryId,
            category: category,
            isPending: isPending,
            isTransfer: isTransfer,
            isExpense: isExpense,
            isEdited: isEdited
        )
    }
}

// MARK: - Category (unchanged)

struct Category {
    let id: Int
    let name: String
    let icon: FontAwesomeCode
    var mainCategoryId: Int?
}

extension Category {
    static let autoAndTransport    = Category(id: 1,   name: "Auto & Transport",       icon: .car_alt)
    static let billsAndUtilities   = Category(id: 2,   name: "Bills & Utilities",       icon: .file_invoice_dollar)
    static let entertainment       = Category(id: 3,   name: "Entertainment",           icon: .film)
    static let feesAndCharges      = Category(id: 4,   name: "Fees & Charges",          icon: .hand_holding_usd)
    static let foodAndDining       = Category(id: 5,   name: "Food & Dining",           icon: .hamburger)
    static let home                = Category(id: 6,   name: "Home",                    icon: .home)
    static let income              = Category(id: 7,   name: "Income",                  icon: .dollar_sign)
    static let shopping            = Category(id: 8,   name: "Shopping",                icon: .shopping_cart)
    static let transfer            = Category(id: 9,   name: "Transfer",                icon: .exchange_alt)

    static let publicTransportation = Category(id: 101, name: "Public Transportation",  icon: .bus,              mainCategoryId: 1)
    static let taxi                 = Category(id: 102, name: "Taxi",                   icon: .taxi,             mainCategoryId: 1)
    static let mobilePhone          = Category(id: 201, name: "Mobile Phone",           icon: .mobile_alt,       mainCategoryId: 2)
    static let moviesAndDVDs        = Category(id: 301, name: "Movies & DVDs",          icon: .film,             mainCategoryId: 3)
    static let bankFee              = Category(id: 401, name: "Bank Fee",               icon: .hand_holding_usd, mainCategoryId: 4)
    static let financeCharge        = Category(id: 402, name: "Finance Charge",         icon: .hand_holding_usd, mainCategoryId: 4)
    static let groceries            = Category(id: 501, name: "Groceries",              icon: .shopping_basket,  mainCategoryId: 5)
    static let restaurants          = Category(id: 502, name: "Restaurants",            icon: .utensils,         mainCategoryId: 5)
    static let rent                 = Category(id: 601, name: "Rent",                   icon: .house_user,       mainCategoryId: 6)
    static let homeSupplies         = Category(id: 602, name: "Home Supplies",          icon: .lightbulb,        mainCategoryId: 6)
    static let paycheck             = Category(id: 701, name: "Paycheck",               icon: .dollar_sign,      mainCategoryId: 7)
    static let software             = Category(id: 801, name: "Software",               icon: .icons,            mainCategoryId: 8)
    static let creditCardPayment    = Category(id: 901, name: "Credit Card Payment",    icon: .exchange_alt,     mainCategoryId: 9)
}

extension Category {
    static let categories: [Category] = [
        .autoAndTransport, .billsAndUtilities, .entertainment,
        .feesAndCharges, .foodAndDining, .home,
        .income, .shopping, .transfer
    ]

    static let subCategories: [Category] = [
        .publicTransportation, .taxi, .mobilePhone, .moviesAndDVDs,
        .bankFee, .financeCharge, .groceries, .restaurants,
        .rent, .homeSupplies, .paycheck, .software, .creditCardPayment
    ]

    static let all: [Category] = categories + subCategories
}
