import Foundation
import SwiftUI

var transactionListPreviewData: [Transaction] = {
    guard let url = Bundle.main.url(forResource: "transactions", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let items = try? JSONDecoder().decode([TransactionJSON].self, from: data)
    else {
        print("PreviewData: could not load transactions.json")
        return []
    }
    return items.map { $0.toTransaction() }
}()
