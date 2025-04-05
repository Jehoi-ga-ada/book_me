//
//  BookFormView.swift
//  BookMe
//
//  Created by Aurelly Joeandani on 25/03/25.
//

import SwiftUI
import SwiftData

struct Room: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    var availability: [String: String] // Key: session, Value: status
}

struct BookFormView: View {
    var collabRoom: CollabRoomModel
    
    @State private var userName: String = ""
    @State private var selectedDate = Date()
    @State private var selectedSession: String?
    @State private var isBookingConfirmed = false
    @State private var filteredUserNames: [String] = []
    
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
                
                
                NavigationLink(destination: SelectNameView()){
                    HStack{
                        Text("Select Name")
                            .font(.title3)
                            .bold()
                    }
                }

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
                        message: Text("You have booked Collab Room \(collabRoom.name) at \(selectedSession!) on \(selectedDate, style: .date)"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    BookFormView(collabRoom: CollabRoomModel)
//        .modelContainer(SampleData.shared.modelContainer)
//}
