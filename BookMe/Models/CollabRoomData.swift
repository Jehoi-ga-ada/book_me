//
//  CollabRoomData.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//
import Foundation

final class CollabRoomData {
    static func generateCollabRooms() -> [CollabRoomModel] {
        var pinPointsLocation: [CGPoint] {
            [
                CGPoint(x: 490, y: 120), // Collab 7
                CGPoint(x: 510, y: -30), // Collab 7A
                CGPoint(x: -60, y: 90), // Collab 1
                CGPoint(x: -160, y: 100), // Collab 2
                CGPoint(x: -240, y: 60), // Collab 3
                CGPoint(x: -415, y: -230), // Collab 5
                CGPoint(x: -500, y: -110), // Collab 4
            ]
        }
        
        var pinPointsZoomLocation: [CGPoint] {
            [
                CGPoint(x: -464.6667, y: -405.0), //0
                CGPoint(x: -463.6666, y: -270.0), //1
                CGPoint(x: 78.6667, y: -379.0),   //2
                CGPoint(x: 191.0, y: -359.3333),  //3
                CGPoint(x: 230.3333, y: -330.3333), //4
                CGPoint(x: 411.3333, y: -83.6667), //5
                CGPoint(x: 460.0, y: -180.0),      //6
            ]
        }
        
        var names: [String] {
            [
                "7",
                "7A",
                "1",
                "2",
                "3",
                "5",
                "4",
            ]
        }
        
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
        
        var images: [[String]] {
            [
                [""],
                [""],
                [""],
                [""],
                [""],
                [""],
                [""],
                [""],
            ]
        }
        
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
