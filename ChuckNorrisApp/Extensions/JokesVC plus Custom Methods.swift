//
//  JokesVC plus Custom Methods.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 17.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit

extension JokesViewController {
    
    // MARK: - Custom Methods
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "JokeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: JokeCell.reuseId)
    }
    
    func setupActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    func setupTextField() {
        numberOfJokesTextField.delegate = self
        numberOfJokesTextField.keyboardType = .numberPad
    }
    
    func setupButton() {
        loadButton.layer.cornerRadius = 15
        loadButton.clipsToBounds = true
    }
    func showAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func toggleUI(_ isOn: Bool) {
        tableView.isHidden = isOn
        numberOfJokesTextField.isHidden = isOn
        loadButton.isHidden = isOn
        activityIndicator.isHidden = !isOn
        activityIndicator.isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
    
    func inputValidation() -> Bool {
        
        guard let unwrappedText = numberOfJokesTextField.text else {
            showAlertController(title: "Error", message: "Fill The Number Of Jokes TextField")
            return false
        }
        
        guard let _ = Int(unwrappedText) else {
            showAlertController(title: "Error", message: "Enter the correct number")
            return false
        }
        
        return true
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
