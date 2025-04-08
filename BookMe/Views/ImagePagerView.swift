//
//  ImagePagerView.swift
//  BookMe
//
//  Created by Jehoiada Wong on 05/04/25.
//

import SwiftUI
import SwiftData

struct ZoomableImage: View {
    let imageName: String
    let index: Int
    @Binding var currentIndex: Int

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        // Calculate new scale and clamp between 1.0 and 3.0
                        let newScale = lastScale * value
                        scale = min(max(newScale, 1.0), 3.0)
                    }
                    .onEnded { _ in
                        lastScale = scale
                    }
            )
            // Reset zoom scale when this image becomes the current image
            .onChange(of: currentIndex) { _, newValue in
                if newValue == index {
                    scale = 1.0
                    lastScale = 1.0
                }
            }
            .onAppear {
                if currentIndex == index {
                    scale = 1.0
                    lastScale = 1.0
                }
            }
    }
}

struct ImagePagerView: View {
    let images: [String]
    @Binding var currentIndex: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Capsule()
                   .fill(Color.secondary)
                   .frame(width: 35, height: 5)
            VStack(spacing: 0) {
                
                // Image pager
                TabView(selection: $currentIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        ZoomableImage(imageName: images[index], index: index, currentIndex: $currentIndex)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.6)
                .cornerRadius(0)
                
                // Page indicator text
                Text("\(currentIndex + 1) / \(images.count)")
                    .foregroundColor(.white)
                    .padding(.top, 10)
            }
            .padding()
        }
    }
}

// Update in BookFormView:
// Replace:
// .sheet(isPresented: $isImagePreviewPresented) {
//     ImagePagerView(images:collabRoom.imagePreviews, currentIndex: $selectedIndex)
// }
//
// With:
// .imagePopup(isPresented: $isImagePreviewPresented,
//             images: collabRoom.imagePreviews,
//             currentIndex: $selectedIndex)
