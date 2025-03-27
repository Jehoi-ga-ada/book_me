//
//  BookingReceiptModel.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import Foundation
import SwiftData

@Model
class BookingReceiptModel: Identifiable{
    var id: UUID = UUID()
    var collab: CollabRoomModel
    var date: Date
    var session: String
    var bookedBy: PersonModel
    var pin: String
    
    init(collab: CollabRoomModel, date: Date, session: String, bookedBy: PersonModel, pin: String) {
        self.collab = collab
        self.date = date
        self.session = session
        self.bookedBy = bookedBy
        self.pin = pin
    }
    
    static let sampleData = BookingReceiptData.createDummyBookingReceipts()
}
