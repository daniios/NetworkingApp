//
//  NetworkManager.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 22.06.2023.
//

import Foundation

enum Link {
    case monstersURL
    
    var url: URL {
        switch self {
        case .monstersURL:
            return URL(string: "https://botw-compendium.herokuapp.com/api/v2/category/monsters")!
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init () {}
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
}
