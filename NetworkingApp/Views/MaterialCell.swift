//
//  MonsterCell.swift
//  NetworkingApp
//
//  Created by Даниил Чупин on 25.06.2023.
//

import UIKit

final class MaterialCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var materialImage: UIImageView! {
        didSet {
            materialImage.clipsToBounds = true
            materialImage.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var materialNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationsLabel: UILabel!
    @IBOutlet weak var heartsLabel: UILabel!
    @IBOutlet weak var effectLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - Public methods
    func configure(with material: Material) {
        materialNameLabel.text = material.name
        descriptionLabel.text = "Info: \(material.description)"
        locationsLabel.text = material.formattedCommonLocations
        heartsLabel.text = "Hearts: \(material.heartsWithColor)"
        effectLabel.text = "Effects: \(material.cookingEffect)"
        
        materialImage.image = nil
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        networkManager.fetchData(from: material.image) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.spinner.stopAnimating()
                self?.materialImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
