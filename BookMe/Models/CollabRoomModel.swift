//
//  CollabRoomModel.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//
import Foundation

struct CollabRoomModel: Identifiable {
    let id: UUID = UUID()
    var name: String
    var pinPointsLocation: CGPoint
    var pinPointsZoomLocation: CGPoint
    var imagePreviews: [String]
}
