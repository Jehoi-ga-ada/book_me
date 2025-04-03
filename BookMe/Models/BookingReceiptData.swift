//
//  BookingReceiptData.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import Foundation

final class BookingReceiptData {
    static func createDummyBookingReceipts() -> [BookingReceiptModel] {
        let session: [String] =
            [
                "08:45 - 09:55",
                "10:10 - 11:20",
                "11:35 - 12:45",
                "13:00 - 14:10",
                "14:25 - 15:35",
                "15:50 - 17:00"
            ]
        
        var dates = [Date]()
        for dayOffset in 0..<5 {
            if let newDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) {
                dates.append(newDate)
            }
        }
        
        let bookedBy: [PersonModel] = PersonModel.sampleData
        
        let collabRooms: [CollabRoomModel] = CollabRoomModel.sampleData
        
        var pin: [String] {
            [
                "1234",
                "2345",
                "3456",
                "4567",
                "5678"
            ]
        }
        
        var bookingReceipts: [BookingReceiptModel] = []
        for i in 0..<bookedBy.count {
            bookingReceipts.append(BookingReceiptModel(collab: collabRooms[i], date: dates[i], session: session[i], bookedBy: bookedBy[i], pin: pin[i]))
        }
        return bookingReceipts
    }
}

extension Date {
    /// Returns a random Date between the given start and end dates.
    static func random(between start: Date, and end: Date) -> Date {
        let lowerBound = min(start, end)
        let upperBound = max(start, end)
        let randomTimeInterval = TimeInterval.random(in: lowerBound.timeIntervalSince1970...upperBound.timeIntervalSince1970)
        return Date(timeIntervalSince1970: randomTimeInterval)
    }
}
