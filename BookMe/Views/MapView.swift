import SwiftUI
import Observation

struct MapView: View {
    let backgroundGradient = LinearGradient(
        colors: [Color("primary", bundle: .main), Color("secondary", bundle: .main)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    @State private var allCollabRooms: [CollabRoomModel] = CollabRoomData.generateCollabRooms()
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @State private var mapScale: CGFloat = 1
    @GestureState private var magnifyBy: CGFloat = 1.0
    
    let minimumZoomScale: CGFloat = 1.0
    let maximumZoomScale: CGFloat = 3.0
    
    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy) { value, gestureState, _ in
                let proposedScale = mapScale * value.magnification
                let clampedScale = min(max(proposedScale, minimumZoomScale), maximumZoomScale)
                gestureState = clampedScale / mapScale
            }
            .onEnded { value in
                let proposedScale = mapScale * value.magnification
                mapScale = min(max(proposedScale, minimumZoomScale), maximumZoomScale)
            }
    }
    
    // The drag gesture is updated to compute dynamic limits based on the map scale.
    func drag(for geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                let newOffset = CGSize(
                    width: lastOffset.width + gesture.translation.width,
                    height: lastOffset.height + gesture.translation.height
                )
                
                // Calculate extra width/height beyond the screen dimensions
                let extraWidth = max((geometry.size.width * mapScale) - geometry.size.width, 0)
                let extraHeight = max((geometry.size.height * mapScale) - geometry.size.height, 0)
                
                // The maximum allowed offset is half the extra dimension.
                let maxAllowedOffsetX = extraWidth / 2
                let maxAllowedOffsetY = extraHeight / 2
                
                let clampedOffset = CGSize(
                    width: min(max(newOffset.width, -maxAllowedOffsetX), maxAllowedOffsetX),
                    height: min(max(newOffset.height, -maxAllowedOffsetY), maxAllowedOffsetY)
                )
                offset = clampedOffset
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }
    
    
    private func focusOnPin(_ pin: CGPoint) {
        withAnimation {
            mapScale = 3.0
            offset = CGSize(width: pin.x, height: pin.y)
            lastOffset = offset
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: - Background
                backgroundGradient
                Rectangle()
                    .fill(
                        ImagePaint(
                            image: Image("map_background"),
                            scale: 0.3
                        )
                    )
                    .opacity(0.65)
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: - Map Content
                ZStack {
                    Image("academy_map")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(mapScale * magnifyBy)
                    
                    ForEach(allCollabRooms, id: \.name) { collabRoom in
                        Button(action: {
                            focusOnPin(collabRoom.pinPointsZoomLocation)
                            print("pin point pressed! \(collabRoom.name)")
                        }) {
                            Image("pin_point")
                                .resizable()
                                .scaledToFit()
                        }
                        .position(collabRoom.pinPointsLocation)
                        .scaleEffect(mapScale / 3 * magnifyBy)
                        .frame(width: 36, height: 40)
                    }
                }
                .offset(offset)
                
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                mapScale = 1.0
                                offset = .zero
                                lastOffset = .zero
                            }
                        } label: {
                            Image(systemName: "backward.circle.fill")
                        }
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
            }
            // Combine the drag and magnification gestures.
            .gesture(drag(for: geometry).simultaneously(with: magnification))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MapView()
}

struct CollabRoomModel {
    var name: String
    var pinPointsLocation: CGPoint
    var pinPointsZoomLocation: CGPoint
    var capacity: Int
}

@Observable
final class CollabRoomData {
    static func generateCollabRooms() -> [CollabRoomModel] {
        var pinPointsLocation: [CGPoint] {
            [
                CGPoint(x: 490, y: 120), // Collab 7
                CGPoint(x: 490, y: 0), // Collab 7A
                CGPoint(x: -60, y: 90), // Collab 1
                CGPoint(x: -160, y: 90), // Collab 2
                CGPoint(x: -220, y: 70), // Collab 3
                CGPoint(x: -395, y: -200), // Collab 5
                CGPoint(x: -470, y: -90), // Collab 4
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
                "Collab 7",
                "Collab 7A",
                "Collab 1",
                "Collab 2",
                "Collab 3",
                "Collab 5",
                "Collab 4",
            ]
        }
        
        var capacaties: [Int] {
            [
                6,
                8,
                8,
                8,
                8,
                8,
                8,
                8
            ]
        }
        
        var collabRooms: [CollabRoomModel] = []
        for i in 0..<names.count {
            collabRooms.append(CollabRoomModel(name: names[i],
                                          pinPointsLocation: pinPointsLocation[i],
                                          pinPointsZoomLocation: pinPointsZoomLocation[i],
                                          capacity: capacaties[i]))
        }
        return collabRooms
    }
}
