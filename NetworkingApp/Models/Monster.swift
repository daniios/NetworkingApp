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
}

struct MonstersResponse: Decodable {
    let data: [Monster]
}
