//
//  ValidatePassView.swift
//  BookMe
//
//  Created by Jehoiada Wong on 07/04/25.
//

import SwiftUI
import SwiftData

struct ValidatePassView: View {
    var correctPin: String
    // Completion callback returning true if PIN is correct, false otherwise.
    let onCompletion: (Bool) -> Void
    @Binding var inputPin: String
    
    // Use the dismiss environment value to close the sheet.
    @Environment(\.dismiss) var dismiss
    
    // New state to control the display of the wrong PIN alert.
    @State private var showWrongPasswordAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            SecureField("Enter a 4-digit PIN", text: $inputPin)
                .keyboardType(.numberPad)
                .onChange(of: inputPin) { oldValue, newValue in
                    if newValue.count > 4 {
                        inputPin = String(oldValue.prefix(4))
                    }
                }
            
            Button("Confirm") {
                if correctPin == inputPin {
                    // Return success and dismiss the view.
                    onCompletion(true)
                    dismiss()
                } else {
                    // Return failure, show alert and clear the input.
                    onCompletion(false)
                    showWrongPasswordAlert = true
                    inputPin = ""
                }
            }
            
            Button("Cancel", role: .cancel) {
                inputPin = ""
                dismiss()
            }
        }
        .alert("Incorrect PIN", isPresented: $showWrongPasswordAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}
