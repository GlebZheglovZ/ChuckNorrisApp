//
//  Extension for StackView.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 17.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        subView.layer.shadowOffset = CGSize(width: 0, height: 3)
        subView.layer.shadowOpacity = 1.0
        subView.layer.shadowRadius = 10.0
        subView.layer.masksToBounds = false
        subView.layer.cornerRadius = 15
        subView.clipsToBounds = true
        insertSubview(subView, at: 0)
    }
}
