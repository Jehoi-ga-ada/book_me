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
        
        // Link this booking with the corresponding collab room and person.
        collab.bookings.append(self)
        bookedBy.bookings.append(self)
    }
    
    // Helper validation function for the PIN.
    // The PIN must have exactly 4 characters and be numeric.
    static func isValidPin(_ pin: String) -> Bool {
        return pin.count == 4 && pin.allSatisfy { $0.isNumber }
    }
    
    static let sampleData = BookingReceiptData.createDummyBookingReceipts()
}
