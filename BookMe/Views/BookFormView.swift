//
//  sheetBookMe.swift
//  BookMe
//
//  Created by Aurelly Joeandani on 25/03/25.
//

import SwiftUI

struct sheetBookMe: View {
    var roomName: String
    var roomImage: String // Nama gambar dalam asset
    @State private var userName: String = ""
    @State private var selectedAvailability: String = ""
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    
    let availabilityOptions = ["Available", "Occupied", "Maintenance"]
        
    var body: some View {
        HStack {
            Text(roomName)
                .font(.largeTitle)
                .padding()
                .foregroundColor(.primary)
                .cornerRadius(10)
            
            Spacer()
            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
            .padding()
            .foregroundColor(.blue)
        }
        VStack(alignment: .leading, spacing: 30) {
            HStack{
                Image(roomImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Image(roomImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Image(roomImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Spacer()
            }
            Button {
                //
            } label: {
                TextField("Enter your name", text: $userName).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }

        }
            VStack(spacing: 20) {
                    
                Picker("Room Availability", selection: $selectedAvailability) {
                            ForEach(availabilityOptions, id: \ .self) { option in Text(option)
                                        }
                                    }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 100)
                                    
                Spacer()
                                    
                Button(action: {
                    print("Room booked by \(userName)")
                }) {
                    Text("Book")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
        }
    private func formattedDate() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: selectedDate)
        }
}

#Preview {
    sheetBookMe(roomName: "Collab Room 1", roomImage: "Collab1")
}
