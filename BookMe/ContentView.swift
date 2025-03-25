import SwiftUI

struct ContentView: View {
    let backgroundGradient = LinearGradient(
        colors: [Color("top_gradient", bundle: .main), Color("bottom_gradient", bundle: .main)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @State private var mapScale: CGFloat = 2
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
    
    var pinPointsLocation: [CGPoint] {
        [
            CGPoint(x: 490, y: 120),
            CGPoint(x: 490, y: 0),
            CGPoint(x: -60, y: 90),
            CGPoint(x: -160, y: 90),
            CGPoint(x: -220, y: 70),
            CGPoint(x: -395, y: -200),
            CGPoint(x: -470, y: -90),
            CGPoint(x: -445, y: -170),
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
            CGPoint(x: 461.0, y: -132.3333),   //7
        ]
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
                    
                    ForEach(pinPointsLocation.indices, id: \.self) { index in
                        let pos = pinPointsLocation[index]
                        let zoom = pinPointsZoomLocation[index]
                        Button(action: {
                            focusOnPin(zoom)
                            print("pin point pressed! \(index)")
                        }) {
                            Image("pin_point")
                                .resizable()
                                .scaledToFit()
                        }
                        .position(pos)
                        .scaleEffect(mapScale / 3 * magnifyBy)
                        .frame(width: 36, height: 40)
                    }
                }
                .offset(offset)
                
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                mapScale = 2.0
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
    ContentView()
}
