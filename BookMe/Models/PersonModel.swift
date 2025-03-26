//
//  PersonModel.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import Foundation

struct PersonModel: Identifiable {
    let id: UUID = UUID()
    var name: String
    var totalBooked: Int
}
