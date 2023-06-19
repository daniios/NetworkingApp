//
//  Monster.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 19.06.2023.
//

import Foundation

struct Monster: Decodable {
    let category: String
    let commonLocations: [String]?
    let description: String
    let drops: [String]?
    let id: Int
    let image: URL
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case category
        case commonLocations = "common_locations"
        case description
        case drops
        case id
        case image
        case name
    }
}

struct MonstersResponse: Decodable {
    let data: [Monster]
}
