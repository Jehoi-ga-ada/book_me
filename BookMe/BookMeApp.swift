//
//  BookMeApp.swift
//  BookMe
//
//  Created by Jehoiada Wong on 17/03/25.
//

import SwiftUI

@main
struct BookMeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MapView()
                .preferredColorScheme(.dark)  // Force Dark Mode
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .modelContainer(SampleData.shared.modelContainer)
        }
    }
}
