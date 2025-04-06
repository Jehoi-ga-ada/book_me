//
//  BookFormView.swift
//  BookMe
//
//  Created by Aurelly Joeandani on 25/03/25.
//

import SwiftUI
import SwiftData

struct BookFormView: View {
    var collabRoom: CollabRoomModel
    
    @State private var userName: String = ""
    @State private var selectedDate = Date()
    @State private var selectedSession: String?
    @State private var isBookingConfirmed = false
    // Hold the selected PersonModel from SelectNameView
    @State private var selectedPerson: PersonModel?
    
    // New state to capture the user's input for a custom PIN.
    @State private var inputPin: String = ""
    // Keep a reference to the booking receipt if one has been created.
    @State private var bookingReceipt: BookingReceiptModel?
    
    @Environment(\.modelContext) private var context
    
    var availability: [String: Bool] {
        collabRoom.availableSessions(on: selectedDate)
    }
    
    @State private var isImagePreviewPresented = false
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Collab Room \(collabRoom.name)")
                        .font(.title)
                        .bold()
                        .padding()
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                        .labelsHidden()
                        .padding()
                }
                
                // Image Preview
                HStack{
                    ForEach(collabRoom.imagePreviews.indices, id: \.self){ idx in
                        Image(collabRoom.imagePreviews[idx])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 80)
                            .clipped()
                            .onTapGesture {
                                // On tap, record the index and present the sheet
                                selectedIndex = idx
                                isImagePreviewPresented.toggle()
                            }
                    }
                }
                .sheet(isPresented: $isImagePreviewPresented) {
                    ImagePagerView(images:collabRoom.imagePreviews, currentIndex: $selectedIndex)
                }
                .padding()
                
                
                // NavigationLink to SelectNameView with a callback
                NavigationLink(destination: SelectNameView { person in
                    self.selectedPerson = person
                }) {
                    HStack {
                        Text(selectedPerson?.name ?? "Select Name")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Image(systemName: "chevron.right")
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
                
                ScrollView {
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
                }
                
                // PIN input field section
                VStack(alignment: .center, spacing: 5) {
                    Text("Enter a 4-digit PIN")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    SecureField("PIN", text: $inputPin)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                        .onChange(of: inputPin) { newValue in
                            if newValue.count > 4 {
                                inputPin = String(newValue.prefix(4))
                            }
                        }
                }
                .padding(.vertical)
                
                // The button label changes based on whether this is a new booking or an update.
                Button(action: bookOrUpdateBooking) {
                    Text(bookingReceipt == nil ? "Book Room" : "Update PIN")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background((selectedSession != nil && selectedPerson != nil && !inputPin.isEmpty) ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(selectedSession == nil || selectedPerson == nil || inputPin.isEmpty)
                .padding(.top, 10)
                .alert(isPresented: $isBookingConfirmed) {
                    Alert(
                        title: Text(bookingReceipt == nil ? "Booking Confirmed" : "PIN Updated"),
                        message: Text("Your booking for Collab Room \(collabRoom.name) at \(selectedSession ?? "") on \(selectedDate, style: .date) now has PIN \(inputPin)"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
    private func bookOrUpdateBooking() {
        // Ensure both a session and a person have been selected.
        guard let session = selectedSession, let person = selectedPerson else {
            return
        }
        
        // Validate the custom PIN using the helper.
        guard BookingReceiptModel.isValidPin(inputPin) else {
            // In a real app, consider displaying an error message here.
            return
        }
        
        // If a booking already exists, update its PIN.
        if let existingReceipt = bookingReceipt {
            existingReceipt.pin = inputPin
        } else {
            // Create a new booking receipt using the user's input PIN.
            let newReceipt = BookingReceiptModel(collab: collabRoom, date: selectedDate, session: session, bookedBy: person, pin: inputPin)
            context.insert(newReceipt)
            bookingReceipt = newReceipt
            try? context.save()
        }
        
        isBookingConfirmed = true
    }
}

//#Preview {
//    BookFormView(collabRoom: CollabRoomModel)
//        .modelContainer(SampleData.shared.modelContainer)
//}
