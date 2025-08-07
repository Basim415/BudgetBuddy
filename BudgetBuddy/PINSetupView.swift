//
//  PINSetupView.swift
//  BudgetBuddy
//
//  Created by Basim Shahzad on 8/7/25.
//

import SwiftUI

struct PINSetupView: View {
    @Binding var isAuthenticated: Bool
    @State private var pin = ""
    @State private var confirmPin = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Set Your PIN")
                .font(.title2)
                .bold()

            SecureField("Enter PIN", text: $pin)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Confirm PIN", text: $confirmPin)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Save PIN") {
                if pin.isEmpty || confirmPin.isEmpty {
                    errorMessage = "Both fields are required"
                } else if pin != confirmPin {
                    errorMessage = "PINs do not match"
                } else {
                    KeychainHelper.shared.save(pin: pin)
                    isAuthenticated = true
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
