//
//  BiometricAuth.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/7/25.
//

import SwiftUI
import Foundation
import LocalAuthentication

class BiometricAuth {
    func authenticate(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access BudgetBuddy"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, authError?.localizedDescription)
                    }
                }
            }
        } else {
            completion(false, "Biometric authentication not available")
        }
    }
}
