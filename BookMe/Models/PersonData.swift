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
    
    static func loadFromJSON() -> [PersonModel] {
            // Try to get the file URL
            guard let url = Bundle.main.url(forResource: "person_data", withExtension: "json") else {
                print("JSON file not found")
                return []
            }
            
            do {
                // Load the data from the file
                let data = try Data(contentsOf: url)
                
                // Decode the JSON data
                let decoder = JSONDecoder()
                let jsonArray = try decoder.decode([PersonNameData].self, from: data)
                // Convert to PersonModel objects
                return jsonArray.map { PersonModel(name: $0.name, totalBooked: 0) }
            } catch {
                print("Error loading or parsing JSON: \(error)")
                return []
            }
        }
}

struct PersonNameData: Codable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try c.decode(String.self, forKey: .name)
        print(self.name)
    }
}
