//
//  HistroyView.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    
    public let backgroundGradient = LinearGradient(
        colors: [Color("PrimeColor", bundle: .main), Color("SecondColor", bundle: .main)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    @State private var searchText: String = ""
    @Query private var bookingReceipts: [BookingReceiptModel]
    
    @State private var focusedCardId: UUID? = nil
    
    var onFocusOnPin: ((CGPoint, GeometryProxy) -> Void)?
    var geometry: GeometryProxy?
    
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
                    .searchable(text: $searchText, prompt: "Search Booking History")
                ScrollView {
                    ForEach(filteredReceipts) { receipt in
                        // Using updated wrapper
                        HistoryCardWrapper(
                            model: receipt,
                            focusedCardId: $focusedCardId,
                            onFocusOnPin: onFocusOnPin,
                            geometry: geometry
                        )
                        .padding(8)
                    }
                }
            }
        }
    }
}

struct HistoryCardWrapper: View {
    @Environment(\.modelContext) private var context
    
    var model: BookingReceiptModel
    @Binding var focusedCardId: UUID?
    
    var onFocusOnPin: ((CGPoint, GeometryProxy) -> Void)?
    var geometry: GeometryProxy?
    
    // Computed binding for the onFocus state
    private var onFocusBinding: Binding<Bool> {
        Binding<Bool>(
            get: { focusedCardId == model.id },
            set: { newValue in
                if newValue {
                    focusedCardId = model.id
                }
            }
        )
    }
    
    var body: some View {
        HistoryCard(
            model: model,
            onFocus: onFocusBinding,
            onCardClick: {
                focusedCardId = model.id
                handleCardClick(model: model)
            },
            onDelete: {
                deleteItem(model)
            },
            onEdit: {
                deleteItem(model)
            }
        )
    }
    
    private func handleCardClick(model: BookingReceiptModel) {

        
        if let onFocusOnPin = onFocusOnPin, let geometry = geometry {
            onFocusOnPin(model.collab.pinPointsZoomLocation.cgPoint, geometry)
        }
    }
    
    private func deleteItem(_ item: BookingReceiptModel) {
        context.delete(item) // Remove from SwiftData
        try? context.save() // Save changes
    }
}

#Preview {
    HistoryView()
        .modelContainer(SampleData.shared.modelContainer)
}
