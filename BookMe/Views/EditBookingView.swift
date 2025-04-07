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
    @State private var isPinVerificationPresented = false
    @State private var inputPin: String = ""
    @State private var isPinVerified = false
    
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
        VStack {
                editFormView
        }
        .onAppear {
            // Show PIN verification when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               // isPinVerificationPresented = true
            }
        }
       
    }
    
    // PIN verification view
    private var pinVerificationView: some View {
        VStack {
            Text("Verifying PIN...")
                .font(.title)
                .padding()
            
            Button("Enter PIN Again") {
                isPinVerificationPresented = true
            }
            .padding()
            
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.red)
            .padding()
        }
    }
    
    // Edit form view
    private var editFormView: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Edit Booking: Booking Room \(bookingReceipt.collab.name)")
                        .font(.title)
                        .bold()
                        .padding()
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                        .labelsHidden()
                        .padding()
                }
                
                // Person Selection
                NavigationLink(destination: SelectNameView { person in
                    self.selectedPerson = person
                }) {
                    HStack {
                        Text(selectedPerson?.name ?? "Select Name").foregroundColor(.prime)
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Divider().padding(.vertical)
                
                Text("Select a Session")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 5)
                
                // Session selection
                VStack(alignment: .leading) {
                    ForEach(availability.keys.sorted(), id: \.self) { session in
                        let isAvailable = availability[session] ?? false
                        HStack {
                            Text(session)
                                .font(.subheadline)
                            Spacer()
                            Text(isAvailable ? "Available" : "Unavailable")
                                .foregroundColor(isAvailable ? .green : .red)
                                .padding(.horizontal, 10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if isAvailable {
                                selectedSession = session
                            }
                        }
                        .padding()
                        .background(selectedSession == session ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                // Update button
                Spacer()

                Button(action: {
                    updateBooking()
                }) {
                    Text("Update Booking")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            (selectedSession == nil || selectedPerson == nil) ?
                                Color.gray.opacity(0.5) :
                                    .prime
                        )
                        .cornerRadius(10)
                }
                .disabled(selectedSession == nil || selectedPerson == nil)
                .padding(.horizontal)
                .padding(.vertical, 16)
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
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
