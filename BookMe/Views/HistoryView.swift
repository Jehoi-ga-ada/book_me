//
//  HistroyView.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import SwiftUI

struct HistoryView: View {
    public let backgroundGradient = LinearGradient(
        colors: [Color("PrimeColor", bundle: .main), Color("SecondColor", bundle: .main)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    @State private var searchText: String = ""
    private let bookingReceipts: [BookingReceiptModel] = BookingReceiptData.createDummyBookingReceipts()
    
    var filteredReceipts: [BookingReceiptModel] {
        bookingReceipts.filter {
            searchText.isEmpty || $0.collab.name.lowercased().contains(searchText.lowercased()) || $0.bookedBy.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                Text("")
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Welcome To BookMe")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color("PrimeColor"))
                                .padding(.top, 40)
                        }
                    }
                .searchable(text: $searchText , prompt: "Search Booking History")
                ScrollView {
                        ForEach(filteredReceipts) { receipt in
                            HistoryCard(model: receipt)
                                .padding(8)
                        }
                }
            }
        }
    }
}

#Preview{
    HistoryView()
}
