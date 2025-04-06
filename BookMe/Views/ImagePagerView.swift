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
            // TODO: Harus update codenya karena method kyk gini udh deprecated
            .onChange(of: currentIndex) { newValue in
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

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(images.indices, id: \.self) { index in
                ZoomableImage(imageName: images[index], index: index, currentIndex: $currentIndex)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(Color.black) // optional styling
    }
}
