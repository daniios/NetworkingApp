//
//  MonstersViewController.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 22.06.2023.
//

import UIKit

final class MonstersViewController: UITableViewController {
    
    private var monstersResponse: MonstersResponse?
    private var monsters: [Monster] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 300
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        monsters.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = cell as? MonsterCell else { return UITableViewCell() }
        
        let course = monsters[indexPath.row]
        cell.configure(with: course)
        
        return cell
    }


}

// MARK: - Networking
extension MonstersViewController {
    func fetchMonsters() {
        URLSession.shared.dataTask(with: Link.monstersURL.url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "no error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy = .convertFromSnakeCase
                self?.monstersResponse = try decoder.decode(MonstersResponse.self, from: data)
                self?.monsters = (self?.monstersResponse!.data)!
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
