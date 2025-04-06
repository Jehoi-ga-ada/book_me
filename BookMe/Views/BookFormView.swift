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
    
    @State private var alertController = AlertViewController()
    
    @State private var userName: String = ""
    @State private var selectedDate = Date()
    @State private var selectedSession: String?
    @State private var isBookingConfirmed = false
    @State private var isPinAlertPresented = false
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
                }
                
                // book button
                Button("Book Room") {
                    isPinAlertPresented = true
                }
                .disabled(selectedSession == nil || selectedPerson == nil)
                .alert("Enter PIN", isPresented: $isPinAlertPresented) {
                    SecureField("Enter a 4-digit PIN", text: $inputPin)
                        .keyboardType(.numberPad)
                        .onChange(of: inputPin) { oldValue, newValue in
                            if newValue.count > 4 {
                                inputPin = String(oldValue.prefix(4))
                            }
                        }
                    Button("Confirm") {
                        bookRoom()
                    }
                    Button("Cancel", role: .cancel) {
                        inputPin = ""
                    }
                }
            }
        }
        .withAlertController(alertController)
    }
    
    // MARK: Booking + Success alert logic
    private func bookRoom() {
        guard let session = selectedSession, let person = selectedPerson, BookingReceiptModel.isValidPin(inputPin) else {
            // Handle invalid input or show an error message
            alertController.showErrorAlert(
                title: "Invalid Input",
                message: "Please ensure all fields are correctly filled.",
                retryButtonText: "Retry",
                cancelButtonText: "Cancel",
                retryAction: {
                    // Code to retry booking
                },
                cancelAction: {
                    // Code to handle cancellation
                }
            )
            return
        }
        
        let newReceipt = BookingReceiptModel(collab: collabRoom, date: selectedDate, session: session, bookedBy: person, pin: inputPin)
        context.insert(newReceipt)
        do {
            try context.save()
            isBookingConfirmed = true
            inputPin = ""
            selectedSession = nil
            selectedPerson = nil
            alertController.showBasicAlert(
                title: "Booking Confirmed",
                message: "Your booking has been successfully recorded."
            )
        } catch {
            alertController.showErrorAlert(
                title: "Booking Failed",
                message: "An error occurred while saving your booking.",
                retryButtonText: "Retry",
                cancelButtonText: "Cancel",
                retryAction: {
                    bookRoom()
                },
                cancelAction: {
                    // Code to handle cancellation
                }
            )
        }
    }
}

//#Preview {
//    BookFormView(collabRoom: CollabRoomModel)
//        .modelContainer(SampleData.shared.modelContainer)
//}
