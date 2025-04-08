//
//  SelectNameView.swift
//  BookMe
//
//  Created by Jehoiada Wong on 05/04/25.
//

import SwiftUI
import SwiftData

struct SelectNameView: View {
    @Environment(\.modelContext) private var context
    @Query private var persons: [PersonModel]
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    
    var onPersonSelected: (PersonModel) -> Void
    
    var filteredPersons: [PersonModel] {
        let filtered = searchText.isEmpty ? persons : persons.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredPersons) { person in
                    Text(person.name)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onPersonSelected(person)
                            dismiss()
                        }
                }
            }
            .searchable(text: $searchText, prompt: "Search Name")
            .navigationTitle("Select Your Name")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SelectNameView { _ in }
        .preferredColorScheme(.dark)
        .modelContainer(SampleData.shared.modelContainer)
}
