//
//  ImagePagerView.swift
//  BookMe
//
//  Created by Jehoiada Wong on 05/04/25.
//

import SwiftUI
import SwiftData

struct ImagePagerView: View {
    let images: [String]
    @Binding var currentIndex: Int
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(images.indices, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFit()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(Color.black) // optional styling
    }
}
