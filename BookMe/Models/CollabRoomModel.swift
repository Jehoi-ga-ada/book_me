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
    
    init(name: String, pinPointsLocation: CGPoint, pinPointsZoomLocation: CGPoint, imagePreviews: [String]) {
        self.name = name
        self.pinPointsLocation = CodablePoint(pinPointsLocation)
        self.pinPointsZoomLocation = CodablePoint(pinPointsZoomLocation)
        self.imagePreviews = imagePreviews
    }
    
    static let sampleData = CollabRoomData.generateCollabRooms()
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
