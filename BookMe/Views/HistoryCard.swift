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
    // onDelete is now called after the deletion success alert is dismissed.
    var onDelete: () -> Void
    var onEdit: () -> Void
    
    // States for showing the PIN validation alerts.
    @State private var isPinDeleteAlertPresented = false
    @State private var isPinEditAlertPresented = false
    @State private var inputPin: String = ""
    
    // Enum to track the deletion alert outcome.
    enum DeletionAlertType: Identifiable {
        case success, wrongPassword
        var id: Int { hashValue }
    }
    @State private var deletionAlertType: DeletionAlertType?
    
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
                    Button("Edit") {
                        isPinEditAlertPresented = true
                    }
                    .font(.headline)
                    .bold()
                    .frame(width: 60)
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 8)
                    .background(Color.orange)
                    .cornerRadius(999)
                    // Present ValidatePassView for editing.
                    .alert("Enter your PIN", isPresented: $isPinEditAlertPresented) {
                        ValidatePassView(correctPin: model.pin, onCompletion: { success in
                            if success {
                                onEdit()
                            }
                        }, inputPin: $inputPin)
                    }
                    
                    Spacer()
                    
                    Button("Delete") {
                        isPinDeleteAlertPresented = true
                    }
                    .font(.headline)
                    .bold()
                    .frame(width: 60)
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 8)
                    .background(Color.red)
                    .cornerRadius(999)
                    // Present ValidatePassView for deletion.
                    .alert("Enter your PIN", isPresented: $isPinDeleteAlertPresented) {
                        ValidatePassView(correctPin: model.pin, onCompletion: { success in
                            if success {
                                // Set the deletion alert to success.
                                deletionAlertType = .success
                            } else {
                                deletionAlertType = .wrongPassword
                            }
                        }, inputPin: $inputPin)
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
        // Alert for deletion outcome.
        .alert(item: $deletionAlertType) { type in
            switch type {
            case .success:
                // When dismissed, trigger onDelete.
                return Alert(title: Text("Deleted"),
                             message: Text("Booking has been deleted."),
                             dismissButton: .default(Text("OK"), action: {
                                onDelete()
                             }))
            case .wrongPassword:
                return Alert(title: Text("Error"),
                             message: Text("Incorrect PIN."),
                             dismissButton: .default(Text("OK")))
            }
        }
    }
}
