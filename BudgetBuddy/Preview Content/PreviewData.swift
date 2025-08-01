import Foundation
import SwiftUI

var transactionListPreviewData: [Transaction] = {
    guard let url = Bundle.main.url(forResource: "transactions", withExtension: "json") else {
        print("transactions.json not found in bundle.")
        return []
    }

    guard let data = try? Data(contentsOf: url) else {
        print("Failed to load data from transactions.json.")
        return []
    }

    do {
        let transactions = try JSONDecoder().decode([Transaction].self, from: data)
        print("Successfully decoded \(transactions.count) transactions.")
        return transactions
    } catch {
        print("Decoding error: \(error)")
        return []
    }
}()

