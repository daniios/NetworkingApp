//
//  MonstersViewController.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 25.06.2023.
//

import UIKit

final class MaterialsViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    private var materials: [Material] = []
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 300
        
        setupActivityIndicator()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        materials.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "materialCell", for: indexPath)
        guard let cell = cell as? MaterialCell else { return UITableViewCell() }
        
        let material = materials[indexPath.row]
        cell.configure(with: material)
        
        return cell
    }
    
    // MARK: - Private methods
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
extension MaterialsViewController {
    func fetchMaterials() {
        networkManager.fetchMaterials(from: Link.materialsURL.url) { [weak self] result in
            switch result {
            case .success(let materials):
                self?.activityIndicator.stopAnimating()
                self?.materials = materials
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
