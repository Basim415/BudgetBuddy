//
//  KeychainHelper+APIKey.swift
//  BudgetBuddy
//
//  Extends KeychainHelper to securely store the Anthropic API key.
//  Drop this file next to KeychainHelper.swift — no edits to the original needed.
//

import Foundation
import Security

extension KeychainHelper {

    private static let apiKeyAccount = "anthropicAPIKey"

    func saveAPIKey(_ key: String) {
        guard let data = key.data(using: .utf8) else { return }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Self.apiKeyAccount,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    func getAPIKey() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Self.apiKeyAccount,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let key = String(data: data, encoding: .utf8) else { return nil }
        return key
    }

    func deleteAPIKey() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Self.apiKeyAccount
        ] as CFDictionary
        SecItemDelete(query)
    }
}
