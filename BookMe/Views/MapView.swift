import SwiftUI
import SwiftData

struct MapView: View {
    @Environment(\.modelContext) private var context

    let backgroundGradient = LinearGradient(
        colors: [Color("PrimeColor", bundle: .main), Color("SecondColor", bundle: .main)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    @Query private var allCollabRooms: [CollabRoomModel]
    @State private var selectedCollabRoom: CollabRoomModel? = nil
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @State private var mapScale: CGFloat = 1
    @GestureState private var magnifyBy: CGFloat = 1.0
    
    let minimumZoomScale: CGFloat = 1.0
    let maximumZoomScale: CGFloat = 3.0
    
    @State private var showingBottomSheet: Bool = true
    @State private var showingBookingForm: Bool = false
    @State private var bottomSheetHeight: PresentationDetent = .height(64)
    
    // New state to track the booking sheet detent
    @State private var bookingSheetDetent: PresentationDetent = .height(450)
    
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
    
    private func focusAndBook(collabRoom: CollabRoomModel, geometry: GeometryProxy) {
        // First set the room, then show the sheet
        selectedCollabRoom = collabRoom
        focusOnPin(collabRoom.pinPointsZoomLocation.cgPoint, geometry: geometry)
        
        // Reset sheet detent to medium
        bookingSheetDetent = .height(450)
        // Hide bottom sheet first
        showingBottomSheet = false
        
        // Show booking form only after we have set the selected room
        showingBookingForm = true
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
                        ) {
                            focusAndBook(collabRoom: collabRoom, geometry: geometry)
                        }
                    }
                }
                .offset(offset)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            withAnimation {
                                mapScale = 1.0
                                offset = .zero
                                lastOffset = .zero
                            }
                        } label: {
                            Image("ResetButton")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(Color.dark.opacity(0.7))
                                .cornerRadius(25)
                                .padding()
                                .shadow(radius: 4)
                        }
                        .padding(.bottom, 100) // Adjust to ensure it's above the bottom sheet
                    }
                }
            }
            .gesture(drag(for: geometry).simultaneously(with: magnification))
            .ignoresSafeArea()
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
                }
            }
            // Only display the booking form sheet when we know the selected room exists
            .onChange(of: showingBookingForm) { oldValue, newValue in
                // If trying to show booking form but no room is selected, reset the state
                if newValue && selectedCollabRoom == nil {
                    showingBookingForm = false
                    showingBottomSheet = true
                }
                
            }
            .sheet(isPresented: $showingBookingForm, onDismiss: {
                // Make sure to show bottom sheet when booking form is dismissed
                showingBookingForm = false
                showingBottomSheet = true
            }) {
                // Using a non-optional BookFormView since we ensure the room is set before showing the sheet
                
                BookFormView(collabRoom: selectedCollabRoom!)
                    .presentationDetents([bookingSheetDetent, .large], selection: $bookingSheetDetent)
                    .presentationBackgroundInteraction(.enabled(upThrough: .large))
                    .presentationBackground {
                        Color.dark
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
