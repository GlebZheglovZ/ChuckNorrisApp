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
    // User Interface Methods
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
        loadButton.backgroundColor = .black
        loadButton.clipsToBounds = true
    }
    
    func createDoneButton() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                         target: nil,
                                         action: nil)
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: .done,
                                         target: self,
                                         action: #selector(self.doneClicked))
        doneButton.tintColor = .black
        toolBar.setItems([flexButton, doneButton],
                         animated: false)
        return toolBar
    }
    
    func setupKeyboard() {
        let done = createDoneButton()
        numberOfJokesTextField.inputAccessoryView = done
    }
    
    func setupUI() {
        setupButton()
        setupTableView()
        setupTextField()
        setupKeyboard()
        setupActivityIndicator()
    }

    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}
