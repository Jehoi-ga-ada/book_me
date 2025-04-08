//
//  CollabRoomData.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//
import Foundation

final class CollabRoomData {
    static func generateCollabRooms() -> [CollabRoomModel] {
        let names: [String] = [
            "Collab Room 1",
            "Collab Room 2",
            "Collab Room 3",
            "Collab Room 4",
            "Collab Room 5",
            "Collab Room 7",
            "Collab Room 7A"
        ]

        let pinPointsLocation: [CGPoint] = [
            CGPoint(x: -60, y: 90),    // Room "1"
            CGPoint(x: -160, y: 100),  // Room "2"
            CGPoint(x: -240, y: 60),   // Room "3"
            CGPoint(x: -500, y: -110), // Room "4"
            CGPoint(x: -415, y: -230), // Room "5"
            CGPoint(x: 490, y: 120),   // Room "7"
            CGPoint(x: 510, y: -30)    // Room "7A"
        ]

        let pinPointsZoomLocation: [CGPoint] = [
            CGPoint(x: 78.6667, y: -379.0),    // Room "1"
            CGPoint(x: 191.0, y: -359.3333),   // Room "2"
            CGPoint(x: 230.3333, y: -330.3333), // Room "3"
            CGPoint(x: 460.0, y: -180.0),       // Room "4"
            CGPoint(x: 411.3333, y: -83.6667),  // Room "5"
            CGPoint(x: -464.6667, y: -405.0),   // Room "7"
            CGPoint(x: -463.6666, y: -270.0)    // Room "7A"
        ]
        
//        var capacaties: [Int] {
//            [
//                6,
//                8,
//                8,
//                8,
//                8,
//                8,
//                8,
//                8
//            ]
//        }
        
        let images: [[String]] =
            [
                ["Collab Room 1", "Collab Room 1", "Collab Room 1"],
                ["Collab Room 2", "Collab Room 2", "Collab Room 2"],
                ["Collab Room 3", "Collab Room 3 - 1", "Collab Room 3 - 2"],
                ["Collab Room 4", "Collab Room 4 - 2", "Collab Room 4 - 3"],
                ["Collab Room 5", "Collab Room 5 - 2", "Collab Room 5 - 3"],
                ["Collab Room 7", "Collab Room 7", "Collab Room 7"],
                ["Collab Room 7A", "Collab Room 7A", "Collab Room 7A"],
            ]
        
        var collabRooms: [CollabRoomModel] = []
        for i in 0..<names.count {
            collabRooms.append(CollabRoomModel(name: names[i],
                                          pinPointsLocation: pinPointsLocation[i],
                                          pinPointsZoomLocation: pinPointsZoomLocation[i],
                                               imagePreviews: images[i]))
        }
        return collabRooms
    }
}
