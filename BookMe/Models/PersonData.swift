//
//  PersonData.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//
import Foundation

final class PersonData {
    static func generateFivePerson() -> [PersonModel] {
        return [
            PersonModel(name: "Sigma", totalBooked: 1),
            PersonModel(name: "Budiono", totalBooked: 4),
            PersonModel(name: "Wahyu", totalBooked: 2),
            PersonModel(name: "Rizzler", totalBooked: 3),
            PersonModel(name: "Broski", totalBooked: 5),
        ]
    }
}
