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
            VStack(spacing: 0) {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("\(model.collab.name)")
                                .font(.title3)
                                .bold()
                            Text("Booked By \(model.bookedBy.name)")
                        }
                        Spacer()
                        VStack() {
                            Text("\(model.date.formatted(date: .numeric, time: .omitted))")
                                .font(.title3)
                                .bold()
                            Text("\(model.session)")
                        }
                        .background(Color.dark)
                        .cornerRadius(0)
                    }
                    Spacer()
                }
                .padding(20)
                
                // Top border for buttons
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color.prime)
                
                // Button row
                HStack(spacing: 0) {
                    // Edit button
                    Button {
                        currentAction = .edit
                        showPinPrompt()
                    } label: {
                        Text("Edit")
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 20)
                            .foregroundColor(.white)
                    }
                    
                    // Middle divider
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(Color.prime)
                    
                    // Delete button
                    Button {
                        currentAction = .delete
                        showPinPrompt()
                    } label: {
                        Text("Delete")
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 20)
                            .foregroundColor(.white)
                    }
                }.background(Color.prime.opacity(0.5))
            }
            .frame(width: 370, height: 150)
            .background(Color.dark)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(onFocus ? Color.red : Color.prime, lineWidth: onFocus ? 8 : 4)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Enter your PIN", isPresented: $isPinPromptShowing) {
            ValidatePassView(inputPin: $inputPin) {
                validatePin()
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
