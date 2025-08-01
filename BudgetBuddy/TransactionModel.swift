//
//  TransactionModel.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 7/15/25.
//

import Foundation
import SwiftUIFontIcon
struct Transaction: Identifiable, Decodable, Hashable {
    let id : Int
    let date: String
    let institution: String
    let account: String
    var merchant: String
    let amount: Double
    let type: TransactionType
    var categoryId: Int
    var category: String
    let isPending: Bool
    var isTransfer: Bool
    var isExpense: Bool
    var isEdited: Bool

    var icon: FontAwesomeCode {
        if let category = Category.all.first(where: {$0.id == categoryId}) {
            return category.icon
        }
        return .question
    }

    var dateParsed: Date {
        date.dateParsed()
    }

    var signedAmount: Double {
        return type == .credit ? amount : -amount
    }
    
    var month: String {
        dateParsed.formatted(.dateTime.year().month(.wide))
    }

    enum TransactionType: String, Decodable, Hashable {
        case debit
        case credit
    }

    // 👇 ADD THIS: required for your custom decoding
    enum CodingKeys: String, CodingKey {
        case id, date, institution, account, merchant, amount, type, categoryId, category, isPending, isTransfer, isExpense, isEdited
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        date = try container.decode(String.self, forKey: .date)
        institution = try container.decode(String.self, forKey: .institution)
        account = try container.decode(String.self, forKey: .account)
        merchant = try container.decode(String.self, forKey: .merchant)
        amount = try container.decode(Double.self, forKey: .amount)
        type = try container.decode(TransactionType.self, forKey: .type)
        categoryId = try container.decode(Int.self, forKey: .categoryId)
        category = try container.decode(String.self, forKey: .category)
        isPending = try container.decode(Bool.self, forKey: .isPending)
        isTransfer = try container.decode(Bool.self, forKey: .isTransfer)
        isExpense = try container.decode(Bool.self, forKey: .isExpense)
        isEdited = try container.decode(Bool.self, forKey: .isEdited)

        // 👇 Helpful debug log
        print("Decoded transaction: \(merchant), type: \(type), amount: \(amount)")
    }
}



struct Category {
    let id: Int
    let name: String
    let icon: FontAwesomeCode
    var mainCategoryId: Int?
    
}

extension Category {
    static let autoAndTransport = Category(id: 1, name: "Auto & Transport", icon: .car_alt)
    static let billsAndUtilities = Category(id: 2, name: "Bills & Utilities", icon: .file_invoice_dollar)
    static let entertainment = Category(id: 3, name: "Entertainment", icon: .film)
    static let feesAndCharges = Category(id: 4, name: "Fees & Charges", icon: .hand_holding_usd)
    static let foodAndDining = Category(id: 5, name: "Food & Dining", icon: .hamburger)
    static let home = Category(id: 6, name: "Home", icon: .home)
    static let income = Category(id: 7, name: "Income", icon: .dollar_sign)
    static let shopping = Category(id: 8, name: "Shopping", icon: .shopping_cart)
    static let transfer = Category(id: 9, name: "Transfer", icon: .exchange_alt)

    static let publicTransportation = Category(id: 101, name: "Public Transportation", icon: .bus, mainCategoryId: 1)
    static let taxi = Category(id: 102, name: "Taxi", icon: .taxi, mainCategoryId: 1)
    static let mobilePhone = Category(id: 201, name: "Mobile Phone", icon: .mobile_alt, mainCategoryId: 2)
    static let moviesAndDVDs = Category(id: 301, name: "Movies & DVDs", icon: .film, mainCategoryId: 3)
    static let bankFee = Category(id: 401, name: "Bank Fee", icon: .hand_holding_usd, mainCategoryId: 4)
    static let financeCharge = Category(id: 402, name: "Finance Charge", icon: .hand_holding_usd, mainCategoryId: 4)
    static let groceries = Category(id: 501, name: "Groceries", icon: .shopping_basket, mainCategoryId: 5)
    static let restaurants = Category(id: 502, name: "Restaurants", icon: .utensils, mainCategoryId: 5)
    static let rent = Category(id: 601, name: "Rent", icon: .house_user, mainCategoryId: 6)
    static let homeSupplies = Category(id: 602, name: "Home Supplies", icon: .lightbulb, mainCategoryId: 6)
    static let paycheck = Category(id: 701, name: "Paycheck", icon: .dollar_sign, mainCategoryId: 7)
    static let software = Category(id: 801, name: "Software", icon: .icons, mainCategoryId: 8)
    static let creditCardPayment = Category(id: 901, name: "Credit Card Payment", icon: .exchange_alt, mainCategoryId: 9)
}

extension Category {
    static let categories: [Category] = [
        .autoAndTransport,
        .billsAndUtilities,
        .entertainment,
        .feesAndCharges,
        .foodAndDining,
        .home,
        .income,
        .shopping,
        .transfer
    ]

    static let subCategories: [Category] = [
        .publicTransportation,
        .taxi,
        .mobilePhone,
        .moviesAndDVDs,
        .bankFee,
        .financeCharge,
        .groceries,
        .restaurants,
        .rent,
        .homeSupplies,
        .paycheck,
        .software,
        .creditCardPayment
    ]
    
    static let all: [Category] = categories + subCategories
}




