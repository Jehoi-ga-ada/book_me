//
//  EditBookingView.swift
//  BookMe
//
//  Created by Vincent Wisnata on 07/04/25.
//

import SwiftUI
import SwiftData

struct EditBookingView: View {
    var bookingReceipt: BookingReceiptModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var alertController = AlertViewController()
    @State private var selectedDate = Date()
    @State private var selectedSession: String?
    @State private var selectedPerson: PersonModel?
    
    // Added a state to track if form is valid
    @State private var isFormValid = true
    
    var availability: [String: Bool] {
        var availableSessions = bookingReceipt.collab.availableSessions(on: selectedDate)
        // Make the current session available if it's on the same date
        if Calendar.current.isDate(selectedDate, inSameDayAs: bookingReceipt.date) {
            availableSessions[bookingReceipt.session] = true
        }
        return availableSessions
    }
    
    init(bookingReceipt: BookingReceiptModel) {
        self.bookingReceipt = bookingReceipt
        _selectedDate = State(initialValue: bookingReceipt.date)
        _selectedSession = State(initialValue: bookingReceipt.session)
        _selectedPerson = State(initialValue: bookingReceipt.bookedBy)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                editFormView
            }
            .navigationBarTitle("Edit Booking", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .withAlertController(alertController)
        }
    }
    
    // Edit form view
    private var editFormView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Booking Room \(bookingReceipt.collab.name)")
                        .font(.title2)
                        .bold()
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                        .labelsHidden()
                }
                .padding(.horizontal)
                
                // Person Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Booked By").font(.headline)
                    
                   
                    HStack {
                        Text(selectedPerson?.name ?? "Select Name")
                            .foregroundColor(.prime)
                            .font(.body)
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Session selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select a Session")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(availability.keys.sorted(), id: \.self) { session in
                        let isAvailable = availability[session] ?? false
                        
                        // Button now wraps the entire content with contentShape
                        Button(action: {
                            if isAvailable {
                                selectedSession = session
                                // Check if form is valid when session changes
                                isFormValid = selectedPerson != nil
                            }
                        }) {
                            HStack {
                                Text(session)
                                    .font(.subheadline)
                                Spacer()
                                Text(isAvailable ? "Available" : "Unavailable")
                                    .foregroundColor(isAvailable ? .green : .red)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(4)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedSession == session
                                ? Color.blue.opacity(0.2)
                                : Color.clear
                            )
                            .cornerRadius(8)
                            // Make the entire area tappable
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(!isAvailable)
                        // Apply opacity to visually indicate disabled status
                        .opacity(isAvailable ? 1.0 : 0.6)
                        .padding(.horizontal)
                    }
                }
                
                Spacer(minLength: 40)
                
                // Update button
                VStack {
                    Button(action: {
                        updateBooking()
                    }) {
                        Text("Update Booking")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                (selectedSession == nil || selectedPerson == nil)
                                ? Color.gray.opacity(0.5)
                                : Color.prime
                            )
                            .cornerRadius(10)
                    }
                    .disabled(selectedSession == nil || selectedPerson == nil)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            // Ensure we validate form state when the view appears
            isFormValid = selectedSession != nil && selectedPerson != nil
        }
    }
    
    // Function to update the booking
    private func updateBooking() {
        guard let session = selectedSession, let person = selectedPerson else {
            alertController.showBasicAlert(
                title: "Invalid Input",
                message: "Please ensure all fields are correctly filled.",
                buttonText: "OK"
            )
            return
        }
        
        // Update booking properties
        bookingReceipt.date = selectedDate
        bookingReceipt.session = session
        bookingReceipt.bookedBy = person
        
        do {
            try context.save()
            alertController.showBasicAlert(
                title: "Booking Updated",
                message: "Your booking has been successfully updated.",
                buttonText: "OK",
                action: {
                    dismiss()
                }
            )
        } catch {
            alertController.showConfirmationAlert(
                title: "Update Failed",
                message: "An error occurred while updating your booking.",
                primaryButtonText: "Retry",
                secondaryButtonText: "Cancel",
                primaryAction: {
                    updateBooking()
                },
                secondaryAction: {
                    dismiss()
                }
            )
        }
    }
}
