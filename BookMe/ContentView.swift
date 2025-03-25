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
    
    // MARK: - Magnification Gesture Logic
    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy) { value, gestureState, transaction in
                let proposedScale = mapScale * value.magnification
                let clampedScale = min(max(proposedScale, minimumZoomScale), maximumZoomScale)
                gestureState = clampedScale / mapScale
            }
            .onEnded { value in
                let proposedScale = mapScale * value.magnification
                mapScale = min(max(proposedScale, minimumZoomScale), maximumZoomScale)
            }
    }
    // MARK: - Drag Gesture Logic
    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                offset = CGSize(
                    width: lastOffset.width + gesture.translation.width,
                    height: lastOffset.height + gesture.translation.height
                )
//                print(offset)
            }
            .onEnded { _ in
                lastOffset = offset
//                print(lastOffset)
            }
    }
    
    // MARK: - Pin Points Coordinates
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
    
    // MARK: - Pin Points Zoom Coordinates
    var pinPointsZoomLocation: [CGPoint] {
        [
            CGPoint(x: -464.6666564941406, y: -404.99998474121094), //0
            CGPoint(x: -463.66664123535156, y: -270.00001525878906), //1
            CGPoint(x: 78.66665649414062, y: -379.0), //2
            CGPoint(x: 191.0, y: -359.3333435058594), //3
            CGPoint(x: 230.3333282470703, y: -330.3333282470703), //4
            CGPoint(x: 411.3333282470703, y: -83.66667175292969), //5
            CGPoint(x: 460.0, y: -180.0), //6
            CGPoint(x: 461.0, y: -132.33334350585938), //7
            
        ]
    }
    
    private func focusOnPin(_ pin: CGPoint) {
        withAnimation {
            // Choose a zoom level
            mapScale = 3.0
            
            // Compute offset so that `pin` is centered in the screen
            offset = CGSize(
                width: pin.x,
                height: pin.y
            )
            
            // Update lastOffset so the new offset becomes the "base" for future drags
            lastOffset = offset
        }
    }
    
    var body: some View {
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
            ZStack{
                Image("academy_map")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(mapScale*magnifyBy)
                ForEach(pinPointsLocation.indices, id: \.self) { index in
                    let pos = pinPointsLocation[index]
                    let zoom = pinPointsZoomLocation[index]
                    Button(action: {
                        focusOnPin(zoom)
                        print("pin point pressed!. \(index)")
                    })
                    {
                        Image("pin_point")
                            .resizable()
                            .scaledToFit()
                    }
                    .position(pos)
                    .scaleEffect(mapScale/3*magnifyBy)
                    .frame(width: 36, height: 40)
                }
            }
            .offset(offset)
            VStack{
                HStack{
                    Button {
                        withAnimation{
                            mapScale = 2.0
                            offset = .zero
                            lastOffset = .zero
                        }
                    } label: {
                        Image(systemName: "backward.circle.fill")
                    }
                    Spacer()
                }
//                Spacer()
            }
        }.gesture(drag.simultaneously(with: magnification))
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
