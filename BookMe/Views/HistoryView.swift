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
    
    var body: some View{
        NavigationStack{
            ScrollView{
                VStack (alignment: .leading){
                    ForEach(filteredReceipts) { receipt in
                        HistoryCard(model: receipt)
                    }
                }
                .navigationTitle("Book History")
            }
        }
        .ignoresSafeArea()
        .searchable(text: $searchText)
    }
}

#Preview{
    HistoryView()
}
