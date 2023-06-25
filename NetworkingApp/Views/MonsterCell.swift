//
//  MonsterCell.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 22.06.2023.
//

import UIKit

final class MonsterCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var monsterImage: UIImageView! {
        didSet {
            monsterImage.clipsToBounds = true
            monsterImage.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var monsterNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dropsLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - Public methods
    func configure(with monster: Monster) {
        monsterNameLabel.text = monster.name
        descriptionLabel.text = "Info: \(monster.description)"
        dropsLabel.text = monster.formattedDrops
        
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
