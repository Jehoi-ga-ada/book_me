import SwiftUI

struct MapView: View {
    let backgroundGradient = LinearGradient(
        colors: [Color("PrimeColor", bundle: .main), Color("SecondColor", bundle: .main)],
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
    
    @State private var showingBottomSheet: Bool = false
    @State private var bottomSheetHeight: PresentationDetent = .height(64)
    
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
    
    // Helper function to compute clamped offset
    private func clampedOffset(for proposedOffset: CGSize, in geometry: GeometryProxy) -> CGSize {
        let extraWidth = max((geometry.size.width * mapScale) - geometry.size.width, 0)
        let extraHeight = max((geometry.size.height * mapScale) - geometry.size.height, 0)
        
        let maxAllowedOffsetX = extraWidth / 2
        let maxAllowedOffsetY = extraHeight / 2
        
        return CGSize(
            width: min(max(proposedOffset.width, -maxAllowedOffsetX), maxAllowedOffsetX),
            height: min(max(proposedOffset.height, -maxAllowedOffsetY), maxAllowedOffsetY)
        )
    }

    // MARK: - Drag Gesture
    func drag(for geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                let newOffset = CGSize(
                    width: lastOffset.width + gesture.translation.width,
                    height: lastOffset.height + gesture.translation.height
                )
                offset = clampedOffset(for: newOffset, in: geometry)
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }
    
    // MARK: - Focus on Pin function
    /// Make this a normal instance method so it can modify `mapScale`, `offset`, etc.
    private func focusOnPin(_ pin: CGPoint, geometry: GeometryProxy) {
        withAnimation {
            mapScale = 3.0
            
            let proposedOffset = CGSize(width: pin.x, height: pin.y)
            offset = clampedOffset(for: proposedOffset, in: geometry)
            lastOffset = offset
        }
    }
    
    // MARK: - Map View
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                
                ZStack {
                    Image("academy_map")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(mapScale * magnifyBy)
                    
                    ForEach(allCollabRooms) { collabRoom in
                        CollabRoomPinView(
                            collabRoom: collabRoom,
                            scale: mapScale / 3 * magnifyBy
                        ) { tappedRoom in
                            focusOnPin(tappedRoom.pinPointsZoomLocation.cgPoint, geometry: geometry)
                            print("Pin point pressed! \(tappedRoom.name)")
                        }
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
            .gesture(drag(for: geometry).simultaneously(with: magnification))
            .ignoresSafeArea()
            .onAppear() {
                showingBottomSheet = true
            }
            .sheet(isPresented: $showingBottomSheet) {
                HistoryViewAdapter(
                    focusOnPinFunction: { pin, geo in
                        focusOnPin(pin, geometry: geo)
                    },
                    geometry: geometry
                )
                .interactiveDismissDisabled()
                .presentationDetents([.height(64), .medium, .large], selection: $bottomSheetHeight)
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .presentationBackground {
                    Color.dark
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.prime, lineWidth: 8)
//                        )
                }
            }
        }
    }
}

struct HistoryViewAdapter: View {
    var focusOnPinFunction: (CGPoint, GeometryProxy) -> Void
    var geometry: GeometryProxy
    
    var body: some View {
        HistoryView(
            onFocusOnPin: { collabRoom, geo in
                focusOnPinFunction(collabRoom, geo)
            },
            geometry: geometry
        )
    }
}

#Preview {
    MapView()
        .preferredColorScheme(.dark)
        .modelContainer(SampleData.shared.modelContainer)
}
