//
//  CollabRoomModel.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//
import Foundation
import SwiftData
import CoreGraphics

@Model
class CollabRoomModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var pinPointsLocation: CodablePoint
    var pinPointsZoomLocation: CodablePoint
    var imagePreviews: [String]
    var session: [String] = [
        "08:45 - 09:55",
        "10:10 - 11:20",
        "11:35 - 12:45",
        "13:00 - 14:10",
        "14:25 - 15:35",
        "15:50 - 17:00"
    ]
    
    // Relationship: list of bookings for this collab room
    var bookings: [BookingReceiptModel] = []
    
    init(name: String, pinPointsLocation: CGPoint, pinPointsZoomLocation: CGPoint, imagePreviews: [String]) {
        self.name = name
        self.pinPointsLocation = CodablePoint(pinPointsLocation)
        self.pinPointsZoomLocation = CodablePoint(pinPointsZoomLocation)
        self.imagePreviews = imagePreviews
    }
    
    static let sampleData = CollabRoomData.generateCollabRooms()
    
    func availableSessions(on date: Date) -> [String: Bool] {
        var availability: [String: Bool] = [:]
        let calendar = Calendar.current
        
        for sessionTime in session {
            // Determine if this session is booked on the given day.
            let isBooked = bookings.contains { booking in
                calendar.isDate(booking.date, inSameDayAs: date) && booking.session == sessionTime
            }
            availability[sessionTime] = !isBooked
        }
        return availability
    }
}

struct CodablePoint: Codable, Hashable {
    var x: CGFloat
    var y: CGFloat
    
    init(_ point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }
    
    var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }
}
