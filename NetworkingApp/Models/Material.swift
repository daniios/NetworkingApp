//
//  Material.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 25.06.2023.
//

import Foundation

struct Material: Codable {
    let category: String
    let commonLocations: [String]
    let cookingEffect: String
    let description: String
    let heartsRecovered: Double
    let id: Int
    let image: String
    let name: String
    
    init(materialData: [String: Any]) {
        category = materialData["category"] as? String ?? ""
        commonLocations = materialData["common_locations"] as? [String] ?? [""]
        cookingEffect = materialData["cooking_effect"] as? String ?? ""
        description = materialData["description"] as? String ?? ""
        heartsRecovered = materialData["hearts_recovered"] as? Double ?? 0.0
        id = materialData["id"] as? Int ?? 0
        image = materialData["image"] as? String ?? ""
        name = materialData["name"] as? String ?? ""
    }
    
    static func getMaterials(from value: Any) -> [Material] {
        guard let materialsData = value as? [[String: Any]] else { return [] }
        return materialsData.map { Material(materialData: $0) }
    }
    
    var heartsWithColor: String {
        if heartsRecovered == 0 {
            return "🖤"
        }
        
        let wholePart = Int(heartsRecovered)
        let fractionalPart = heartsRecovered - Double(wholePart)

        // Выводим целое число сердечек
        let hearts = String(repeating: "❤️", count: wholePart)

        // Определяем цвет для дробной части
        let color: String
        if fractionalPart == 0.5 {
            color = "💙"
        } else {
            color = "❤️"
        }

        // Добавляем сердечко с нужным цветом в зависимости от дробной части
        let heartsWithColor = hearts + (fractionalPart != 0 ? color : "")

        return heartsWithColor
    }
    
    var formattedCommonLocations: String {
        if commonLocations.isEmpty {
            return "Locations: -"
        } else {
            let result = commonLocations.joined(separator: ", ")
            return "Locations: \(result)"
        }
    }
}
