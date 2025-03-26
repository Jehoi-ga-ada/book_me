import SwiftUI
import Observation

struct MapView: View {
    let backgroundGradient = LinearGradient(
        colors: [Color("primaryColor", bundle: .main), Color("secondaryColor", bundle: .main)],
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
    
    // MARK: - Gesture Motion
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
    
    // MARK: - Drag Gesture
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
    
    // MARK: - Focus on Pin function
    private func focusOnPin(_ pin: CGPoint) {
        withAnimation {
            mapScale = 3.0
            offset = CGSize(width: pin.x, height: pin.y)
            lastOffset = offset
        }
    }
    
    // MARK: - Map View
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
                    .opacity(0.7)
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
