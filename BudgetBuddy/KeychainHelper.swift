//
//  KeychainHelper.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/7/25.
//

import Foundation
import SwiftUI
import Security

class KeychainHelper {
    static let shared = KeychainHelper()

    func save(pin: String) {
        let data = pin.data(using: .utf8)!
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "userPIN",
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query) // remove old pin if it exists
        SecItemAdd(query, nil)
    }

    func getPIN() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "userPIN",
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?

        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess,
           let data = dataTypeRef as? Data,
           let pin = String(data: data, encoding: .utf8) {
            return pin
        }

        return nil
    }
}
