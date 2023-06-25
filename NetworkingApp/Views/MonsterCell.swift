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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let networkManager = NetworkManager.shared
    
    func configure(with monster: Monster) {
        monsterNameLabel.text = monster.name
        descriptionLabel.text = "Info: \(monster.description)"
        
        if let drops = monster.drops {
            if drops.count == 0 {
                dropsLabel.text = "Drop: Nothing"
            } else {
                let result = drops.joined(separator: ", ")
                dropsLabel.text = "Drop: \(result)"
            }
        } else {
            dropsLabel.text = "Drop: Nothing"
        }
        
        monsterImage.image = nil
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        networkManager.fetchImage(from: monster.image) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.spinner.stopAnimating()
                self?.monsterImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
            
        }
     
    }
}
