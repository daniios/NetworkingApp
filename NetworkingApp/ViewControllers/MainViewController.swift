//
//  ViewController.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 19.06.2023.
//

import UIKit

enum UserAction: CaseIterable {
    case showMonsters
    case showMaterials
    
    var title: String {
        switch self {
        case .showMonsters:
            return "Monsters"
        case .showMaterials:
            return "Materials"
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

final class MainViewController: UICollectionViewController {
    
    private let userActions = UserAction.allCases
    private let networkManager = NetworkManager.shared
    private var materials: [Material] = []

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath) as! UserActionCell
    
        cell.userActionLabel.text = userActions[indexPath.item].title
    
        return cell
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .showMonsters: performSegue(withIdentifier: "showMonsters", sender: nil)
        case .showMaterials: performSegue(withIdentifier: "showMaterials", sender: nil)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMonsters" {
            guard let monstersVC = segue.destination as? MonstersViewController else { return }
            monstersVC.fetchMonsters()
        }
        if segue.identifier == "showMaterials" {
            guard let materialsVC = segue.destination as? MaterialsViewController else { return }
            materialsVC.fetchMaterials()
        }
    }
    
    private func printMaterials() {
        networkManager.fetchMaterials(from: Link.materialsURL.url) { [weak self] result in
            switch result {
            case .success(let materials):
                self?.materials = materials
                print(self?.materials.description ?? "Problem")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}
