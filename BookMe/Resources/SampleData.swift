//
//  SampleBookingReceiptData.swift
//  BookMe
//
//  Created by Jehoiada Wong on 27/03/25.
//

import Foundation
import SwiftData


@MainActor
class SampleData {
    static let shared = SampleData()


    let modelContainer: ModelContainer


    var context: ModelContext {
        modelContainer.mainContext
    }


    private init() {
        let schema = Schema([
            BookingReceiptModel.self,
            CollabRoomModel.self,
            PersonModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)


        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertSampleData()
            
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insertSampleData() {
        for BookingReceipt in BookingReceiptModel.sampleData {
            context.insert(BookingReceipt)
        }
        
        for CollabRoom in CollabRoomModel.sampleData {
            context.insert(CollabRoom)
        }
        
        for Person in PersonModel.sampleData {
            context.insert(Person)
        }
    }
}
