//
//  CollabRoomPinView.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//


import SwiftUI

struct CollabRoomPinView: View {
    let collabRoom: CollabRoomModel
    
    /// A scale value passed from the parent (e.g., mapScale / 3 * magnifyBy).
    let scale: CGFloat
    
    /// A closure the child can call when the user taps the pin.
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            // Label button
            Button(action: {
                onTap()
            }) {
                Text(collabRoom.name)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color("darkColor").opacity(0.8))
                    .cornerRadius(99)
                    .frame(width: 64, height: 32)
            }
            
            // Pin image button
            Button(action: {
                onTap()
            }) {
                Image("pin_point")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
            }
        }
        .position(collabRoom.pinPointsLocation.cgPoint)
        .scaleEffect(scale)
        .frame(width: 36, height: 40)
    }
}
