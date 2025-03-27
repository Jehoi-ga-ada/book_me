//
//  PersonModel.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import Foundation
import SwiftData

@Model
class PersonModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var totalBooked: Int
    
    init(name: String, totalBooked: Int) {
        self.name = name
        self.totalBooked = totalBooked
    }
}
