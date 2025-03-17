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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
