//
//  HistoryCard.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import SwiftUI

struct HistoryCard: View {
    var model: BookingReceiptModel
    
    var body: some View {
        HStack{
            VStack (alignment: .leading){
                Text("Collab Room \(model.collab.name)")
                Text("Booked By \(model.bookedBy.name)")
            }
            VStack{
                Text("\(model.date.formatted(date: .numeric, time: .omitted))")
                Text("\(model.session)")
            }
            VStack{
                Button(action: {}){
                    Text("Edit")
                }
                Button(action: {}){
                    Text("Delete")
                }
            }
        }
        .frame(width: 370, height: 83)
        .background(Color("PrimeColor"))
        .cornerRadius(24)
    }
}
