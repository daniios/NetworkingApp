//
//  MonsterCell.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 22.06.2023.
//

import UIKit

class MonsterCell: UITableViewCell {

    @IBOutlet var monsterImage: UIImageView!
    @IBOutlet var monsterNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dropsLabel: UILabel!
    
    private let networkManager = NetworkManager.shared
    
    func configure(with monster: Monster) {
        monsterNameLabel.text = monster.name
        descriptionLabel.text = "Info: \(monster.description)"
        
        if let drops = monster.drops {
            let result = drops.joined(separator: ", ")
            dropsLabel.text = "Drop: \(result)"
        } else {
            dropsLabel.text = "Drop: Nothing"
        }
        
        networkManager.fetchImage(from: monster.image) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.monsterImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
            
        }
     
    }
}
