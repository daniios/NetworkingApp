//
//  MonstersViewController.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 22.06.2023.
//

import UIKit

final class MonstersViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var monstersResponse: MonstersResponse?
    private var monsters: [Monster] = []
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 300
        
        setupActivityIndicator()
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
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}

// MARK: - Networking
extension MonstersViewController {
    func fetchMonsters() {
        networkManager.fetch(MonstersResponse.self, from: Link.monstersURL.url) { [weak self] result in
            switch result {
            case .success(let monsters):
                self?.activityIndicator.stopAnimating()
                self?.monsters = monsters.data
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
