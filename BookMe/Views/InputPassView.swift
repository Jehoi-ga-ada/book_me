//
//  PinInputView.swift
//  BookMe
//
//  Created by Jehoiada Wong on 07/04/25.
//
import SwiftUI
import SwiftData

struct InputPassView: View {
    
    let onTap: () -> Void
    @Binding var inputPin: String
    
    var body: some View {
        SecureField("Enter a 4-digit PIN", text: $inputPin)
            .keyboardType(.numberPad)
            .onChange(of: inputPin) { oldValue, newValue in
                if newValue.count > 4 {
                    inputPin = String(oldValue.prefix(4))
                }
            }
        Button("Confirm") {
            onTap()
        }
        Button("Cancel", role: .cancel) {
            inputPin = ""
        }
    }
}
