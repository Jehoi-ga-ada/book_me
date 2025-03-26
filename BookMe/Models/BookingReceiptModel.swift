//
//  BookingReceiptModel.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import Foundation

struct BookingReceiptModel: Identifiable{
    let id: UUID = UUID()
    var collab: CollabRoomModel
    var date: Date
    var session: String
    var bookedBy: PersonModel
    var pin: String
}
