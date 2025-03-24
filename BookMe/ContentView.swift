import SwiftUI

let backgroundGradient = LinearGradient(
    colors: [Color("top_gradient"), Color("bottom_gradient")],
    startPoint: .top,
    endPoint: .bottom
)

struct ContentView: View {
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    @State private var mapScale: CGFloat = 1.5
    @GestureState private var magnifyBy: CGFloat = 1.0
    
    let minimumZoomScale: CGFloat = 1.0
    let maximumZoomScale: CGFloat = 3.0
    
    // MARK: - Magnification Gesture Logic
    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy){ value, gestureState, transaction in
                gestureState = value.magnification
            }.onEnded { value in
                mapScale *= value.magnification
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
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }
    
    // MARK: - Pin Points Location
    var pinPointsLocation: [CGPoint] {
        [
            CGPoint(x: 490, y: 120),
            CGPoint(x: 490, y: 50),
            CGPoint(x: 490, y: 0),
            CGPoint(x: -60, y: 90),
            CGPoint(x: -160, y: 90),
            CGPoint(x: -220, y: 70),
            CGPoint(x: -285, y: -220),
            CGPoint(x: -395, y: -200),
            CGPoint(x: -470, y: -90),
            CGPoint(x: -445, y: -170),
        ]
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
            VStack {
                ZStack{
                    Image("academy_map")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(mapScale*magnifyBy)
                    ForEach(pinPointsLocation.indices, id: \.self) { index in
                        let pos = pinPointsLocation[index]
                        Button(action: {
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
            }
        }.gesture(drag.simultaneously(with: magnification))
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
