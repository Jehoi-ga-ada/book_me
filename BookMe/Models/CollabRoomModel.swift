//
//  CollabRoomModel.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//
import Foundation
import SwiftData

@Model
class CollabRoomModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var pinPointsLocation: CGPoint
    var pinPointsZoomLocation: CGPoint
    var imagePreviews: [String]
    
    init(name: String, pinPointsLocation: CGPoint, pinPointsZoomLocation: CGPoint, imagePreviews: [String]) {
        self.name = name
        self.pinPointsLocation = pinPointsLocation
        self.pinPointsZoomLocation = pinPointsZoomLocation
        self.imagePreviews = imagePreviews
    }
    
    static let sampleData: [CollabRoomModel] = CollabRoomData.generateCollabRooms()
}
