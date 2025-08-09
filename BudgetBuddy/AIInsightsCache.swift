//
//  AIInsightsCache.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/9/25.
//

import Foundation
import CryptoKit

final class InsightsCache {
    static let shared = InsightsCache()
    private init() {}

    func key(month: String, aggHash: String) -> String { "insights_\(month)_\(aggHash)" }

    func load(key: String) -> InsightsEnvelope? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(InsightsEnvelope.self, from: data)
    }

    func save(_ env: InsightsEnvelope, key: String) {
        if let data = try? JSONEncoder().encode(env) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

extension Encodable {
    func toJSONData(pretty: Bool = false) -> Data? {
        let enc = JSONEncoder()
        if pretty { enc.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes, .sortedKeys] }
        return try? enc.encode(self)
    }
    func sha256() -> String {
        guard let data = toJSONData() else { return "" }
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
