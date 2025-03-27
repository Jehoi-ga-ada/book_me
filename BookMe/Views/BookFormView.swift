//
//  sheetBookMe.swift
//  BookMe
//
//  Created by Aurelly Joeandani on 25/03/25.
//

import SwiftUI

struct Room: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    var availability: [String: String] // Key: session, Value: status
}

struct sheetBookMe: View {
    var roomName: String
    var roomImage: String
    @State private var userName: String = ""
    @State private var selectedDate = Date()
    @State private var selectedSession: String?
    @State private var isImagePreviewPresented = false
    @State private var isBookingConfirmed = false
    @State private var filteredUserNames: [String] = []
    
    let sessions = [
        "08:45 - 09:55", "10:10 - 11:20", "11:35 - 12:45",
        "13:00 - 14:10", "14:25 - 15:35", "15:50 - 17:00"
    ]
    
    let userNames = ["Abdul Rahman", "Abdul Karim", "Abdullah Yusuf", "Aisyah Putri", "Budi Santoso"]
    
    @State private var room = Room(name: "Collab Room 1", image: "Collab1", availability: [
        "08:45 - 09:55": "Available", "10:10 - 11:20": "Occupied",
        "11:35 - 12:45": "Available", "13:00 - 14:10": "Maintenance",
        "14:25 - 15:35": "Available", "15:50 - 17:00": "Occupied"
    ])
    
    var body: some View {
        VStack {
            HStack {
                Text(room.name)
                    .font(.title)
                    .bold()
                    .padding()
                Spacer()
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .labelsHidden()
                    .padding()
            }
            
            // Image Preview
            Button(action: {
                isImagePreviewPresented.toggle()
            }) {
                Image(room.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding()
            }
            .sheet(isPresented: $isImagePreviewPresented) {
                Image(room.image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            
            // Autocomplete User Name
            TextField("Enter your name", text: $userName, onEditingChanged: { _ in
                filteredUserNames = userNames.filter { $0.lowercased().contains(userName.lowercased()) }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            
            if !filteredUserNames.isEmpty {
                List(filteredUserNames, id: \..self) { name in
                    Text(name)
                        .onTapGesture {
                            userName = name
                            filteredUserNames = []
                        }
                }
                .frame(height: 100)
            }
            
            Divider().padding(.vertical)
            
            Text("Select a Session")
                .font(.title2)
                .bold()
                .padding(.bottom, 5)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(sessions, id: \..self) { session in
                        HStack {
                            Text(session)
                                .font(.subheadline)
                            Spacer()
                            if let status = room.availability[session] {
                                Text(status)
                                    .foregroundColor(status == "Available" ? .green : (status == "Occupied" ? .red : .orange))
                                    .padding(.horizontal, 10)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        if status == "Available" {
                                            selectedSession = session
                                        }
                                    }
                            }
                        }
                        .padding()
                        .background(selectedSession == session ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            
            Button(action: {
                if selectedSession != nil {
                    isBookingConfirmed.toggle()
                }
            }) {
                Text("Book Room")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedSession != nil ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(selectedSession == nil)
            .padding(.top, 10)
            .alert(isPresented: $isBookingConfirmed) {
                Alert(
                    title: Text("Booking Confirmed"),
                    message: Text("You have booked \(room.name) at \(selectedSession!) on \(selectedDate, style: .date)"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
    }
}

#Preview {
    sheetBookMe(roomName: "Collab Room 1", roomImage: "Collab1")
}
