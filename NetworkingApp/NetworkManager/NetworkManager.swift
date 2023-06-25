//
//  NetworkManager.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 22.06.2023.
//

import Foundation
import Alamofire

enum Link {
    case monstersURL
    case materialsURL
    
    var url: URL {
        switch self {
        case .monstersURL:
            return URL(string: "https://botw-compendium.herokuapp.com/api/v2/category/monsters")!
        case .materialsURL:
            return URL(string: "https://botw-compendium.herokuapp.com/api/v2/category/materials")!
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
    
    // MARK: - URLSession methods for work with Monster data
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
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "no error description")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataModel = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataModel))
                }
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
    // MARK: - Alamofire methods for work with Material data
    func fetchMaterials(from url: URL, completion: @escaping (Result<[Material], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let dataArray = json["data"] as? [[String: Any]] {
                        let materials = Material.getMaterials(from: dataArray)
                        completion(.success(materials))
                    } else {
                        completion(.success([]))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    func fetchData(from url: String, completion: @escaping(Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { dataResponse in
                switch dataResponse.result {
                case .success(let imageData):
                    completion(.success(imageData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
