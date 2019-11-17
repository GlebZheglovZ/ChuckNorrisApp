//
//  JokeCell.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 17.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit

class JokeCell: UITableViewCell {
    
    // MARK: - Class Properties
    
    static let reuseId = "JokeCell"
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var stackViewForCell: UIStackView!
    @IBOutlet weak var backgroundViewForCell: UIView!

    // MARK: - UITableViewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Custom Methods
    
    func setupCell(with joke: Joke) {
        setupBackground()
        cellImage.image = UIImage(named: "chuck")
        cellLabel.text = joke.joke.convertSpecialCharacters()
    }
    
    func applyAnimationForAppearing() {
    
        self.cellLabel.alpha = 0
        self.cellImage.alpha = 0
        self.backgroundViewForCell.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.cellImage.alpha = 1
            self.cellLabel.alpha = 1
            self.backgroundViewForCell.alpha = 1
        }
    }
    
    func setupBackground() {
        backgroundViewForCell.backgroundColor = .orange
        backgroundViewForCell.clipsToBounds = true
        backgroundViewForCell.layer.cornerRadius = 15
        backgroundViewForCell.layer.shadowColor = UIColor.black.cgColor
        backgroundViewForCell.layer.shadowOffset = CGSize(width: 1, height: 1)
        backgroundViewForCell.layer.shadowOpacity = 1.0
        backgroundViewForCell.layer.shadowRadius = 5
        backgroundViewForCell.layer.masksToBounds = false
    }

}
