//
//  JokeCell.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 17.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit

class JokeCell: UITableViewCell {
    
    static let reuseId = "JokeCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var stackViewForCell: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(with joke: Joke) {
        setupBackground()
        cellImage.image = UIImage(named: "chuck")
        cellLabel.text = joke.joke.convertSpecialCharacters()
    }
    
    func applyAnimationForAppearing() {
    
        self.cellLabel.alpha = 0
        self.cellImage.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.cellImage.alpha = 1
            self.cellLabel.alpha = 1
        }
    }
    
    func setupBackground() {
        stackViewForCell.addBackground(color: .orange)
    }

}
