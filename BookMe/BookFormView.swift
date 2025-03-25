//
//  BookFormView.swift
//  BookMe
//
//  Created by Jehoiada Wong on 24/03/25.
//

import SwiftUI

struct BookFormView: View {
    var colab_name: String = "Collab Room 1"
    @State private var date = Date()
    @State private var name: String = "Budiono"
    
    var body: some View {
        VStack{
            HStack{
                Text(colab_name)
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
            }
            HStack{
                Image(systemName: "square.and.arrow.up")
                Image(systemName: "square.and.arrow.up")
                Image(systemName: "square.and.arrow.up")
                Spacer()
            }
            List {
                // "Masukan Nama" row
                NavigationLink(destination: ContentView()) {
                    HStack {
                        Text("Masukan Nama")
                        Spacer()
                        // Show the current name in a secondary color
                        Text(name)
                            .foregroundColor(.secondary)
                    }
                }
            }.frame()
            ScrollView{
                
            }
        }
    }
}

#Preview {
    BookFormView()
}
