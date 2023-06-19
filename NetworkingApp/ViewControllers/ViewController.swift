//
//  ViewController.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 19.06.2023.
//

import UIKit

enum Link {
    case monstersURL
    
    var url: URL {
        switch self {
        case .monstersURL:
            return URL(string: "https://botw-compendium.herokuapp.com/api/v2/category/monsters")!
        }
    }
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "You can see the results in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMonsters()
    }
    
    // MARK: - Private Methods
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title,
                                      message: status.message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }

}

extension ViewController {
    private func printMonsterDetails(_ monster: Monster) {
            print("Name: \(monster.name)")
            print("Description: \(monster.description)")
            
            print("Locations:")
            if let commonLocations = monster.commonLocations {
                for location in commonLocations {
                    print(location)
                }
            } else {
                print("No info")
            }
            
            print("Drop:")
            if let drops = monster.drops {
                for drop in drops {
                    print(drop)
                }
            } else {
                print("Nothing")
            }
            print("--------------\n")
    }
    
    private func fetchMonsters() {
        URLSession.shared.dataTask(with: Link.monstersURL.url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let monstersResponse = try decoder.decode(MonstersResponse.self, from: data)
                let monsters = monstersResponse.data
                for monster in monsters {
                    self!.printMonsterDetails(monster)
                }
                
                self?.showAlert(withStatus: .success)
            } catch {
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }.resume()
    }
}
