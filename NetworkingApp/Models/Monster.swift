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
    
    var formattedDrops: String {
        if let drops = drops {
            if drops.isEmpty {
                return "Drop: Nothing"
            } else {
                let result = drops.joined(separator: ", ")
                return "Drop: \(result)"
            }
        } else {
            return "Drop: Nothing"
        }
    }
}

struct MonstersResponse: Decodable {
    let data: [Monster]
}
