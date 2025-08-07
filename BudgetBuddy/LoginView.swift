//
//  LoginView.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/7/25.
//

import Foundation
import SwiftUI


struct LoginView: View {
    @Binding var isAuthenticated: Bool

    @State private var showPINPrompt = false
    @State private var enteredPIN = ""
    @State private var errorMessage = ""

    let biometricAuth = BiometricAuth()

    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to BudgetBuddy")
                .font(.title)
                .bold()

            Button("Unlock with Face ID / Touch ID") {
                biometricAuth.authenticate { success, error in
                    if success {
                        isAuthenticated = true 
                    } else {
                        errorMessage = error ?? "Authentication failed"
                        showPINPrompt = true
                    }
                }
            }

            if showPINPrompt {
                VStack(spacing: 10) {
                    SecureField("Enter PIN", text: $enteredPIN)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Submit PIN") {
                        let storedPIN = KeychainHelper.shared.getPIN()
                        if enteredPIN == storedPIN {
                            isAuthenticated = true
                        } else {
                            errorMessage = "Incorrect PIN"
                        }
                    }
                }
                .padding()
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

