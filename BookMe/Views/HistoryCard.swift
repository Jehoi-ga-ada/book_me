//
//  HistoryCard.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import SwiftUI

struct HistoryCard: View {
    var model: BookingReceiptModel
    @Binding var onFocus: Bool
    var onCardClick: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        Button(action: {
            onCardClick()
        }) {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Collab Room \(model.collab.name)").font(.title).bold()
                        Text("Booked By \(model.bookedBy.name)")
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        Text("\(model.date.formatted(date: .numeric, time: .omitted))").font(.title3).bold()
                        Text("\(model.session)")
                    }
                    .padding()
                    .background(.dark)
                    .cornerRadius(0)
                }
                Spacer()
                HStack {
                    Button(action: {}) {
                        Text("Edit").font(.headline).bold()
                            .frame(width: 60)
                            .foregroundColor(.white)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 8)
                    }
                    .background(Color.orange)
                    .cornerRadius(999)
                    Spacer()
                    Button(action: onDelete) {
                        Text("Delete").font(.headline).bold()
                            .frame(width: 60)
                            .foregroundColor(.white)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 8)
                    }
                    .background(Color.red)
                    .cornerRadius(999)
                }.padding(.top, 8)
            }
            .padding(20)
            .frame(width: 370, height: 190)
            .background(Color.dark)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(onFocus ? Color.red : Color.prime, lineWidth: onFocus ? 8 : 4)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
