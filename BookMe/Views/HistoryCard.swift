//
//  HistoryCard.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import SwiftUI

struct HistoryCard: View {
    var model: BookingReceiptModel
    @Binding var onFocus: Bool
    var onCardClick: () -> Void
    var onDelete: () -> Void
    var onEdit: () -> Void
    
    @State private var inputPin: String = ""
    @State private var isPinPromptShowing = false
    @State private var currentAction: PinAction = .edit
    
    // Keep track of which action we're performing
    enum PinAction {
        case edit, delete
    }
    
    // Alert controller for all alerts
    @State private var alertController = AlertViewController()
    
    var body: some View {
        Button(action: {
            onCardClick()
        }) {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Collab Room \(model.collab.name)")
                            .font(.title)
                            .bold()
                        Text("Booked By \(model.bookedBy.name)")
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        Text("\(model.date.formatted(date: .numeric, time: .omitted))")
                            .font(.title3)
                            .bold()
                        Text("\(model.session)")
                    }
                    .padding()
                    .background(Color.dark)
                    .cornerRadius(0)
                }
                Spacer()
                HStack {
                    Button {
                        currentAction = .edit
                        showPinPrompt()
                    } label: {
                        Text("Edit")
                            .font(.headline)
                            .bold()
                            .frame(width: 60)
                            .foregroundColor(.white)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .cornerRadius(999)
                    }
                   
                    
                    Spacer()
                    
                    Button() {
                        currentAction = .delete
                        showPinPrompt()
                    } label: {
                        Text ("Delete") .font(.headline)
                            .bold()
                            .frame(width: 60)
                            .foregroundColor(.white)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 8)
                            .background(Color.red)
                            .cornerRadius(999)
                    }
                   
                }
                .padding(.top, 8)
            }
            .padding(20)
            .frame(width: 370, height: 190)
            .background(Color.dark)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(onFocus ? Color.red : Color.prime, lineWidth: onFocus ? 8 : 4)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Enter your PIN", isPresented: $isPinPromptShowing) {
            SecureField("Enter a 4-digit PIN", text: $inputPin)
                .keyboardType(.numberPad)
                .onChange(of: inputPin) { oldValue, newValue in
                    if newValue.count > 4 {
                        inputPin = String(oldValue.prefix(4))
                    }
                }
            Button("Confirm") {
                validatePin()
            }
            Button("Cancel", role: .cancel) {
                inputPin = ""
            }
        }
        .withAlertController(alertController)
    }
    
    // Show PIN prompt
    private func showPinPrompt() {
        isPinPromptShowing = true
    }
    
    // Validate PIN and perform the appropriate action
    private func validatePin() {
        if inputPin == model.pin {
            inputPin = ""
            
            // PIN is correct, perform the appropriate action
            switch currentAction {
            case .edit:
                onEdit()
            case .delete:
                showDeletionConfirmation()
            }
        } else {
            // PIN is incorrect, show error message
            inputPin = ""
            showIncorrectPinAlert()
        }
    }
    
    // Show incorrect PIN alert using AlertViewController
    private func showIncorrectPinAlert() {
        alertController.showBasicAlert(
            title: "Error",
            message: "Incorrect PIN.",
            buttonText: "OK"
        )
    }
    
    // Show deletion confirmation using AlertViewController
    private func showDeletionConfirmation() {
        alertController.showBasicAlert(
            title: "Deleted",
            message: "Booking has been deleted.",
            buttonText: "OK",
            action: {
                onDelete()
            }
        )
    }
}
