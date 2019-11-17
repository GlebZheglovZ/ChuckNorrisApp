//
//  ViewController.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 16.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit

class JokesViewController: UIViewController {
    
    var receivedJokes = [Joke]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.toggleUI(false)
            }
        }
    }
    
    let networkManager = NetworkManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var numberOfJokesTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActivityIndicator()
    }
    
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
    
    func toggleUI(_ isOn: Bool) {
        tableView.isHidden = isOn
        numberOfJokesTextField.isHidden = isOn
        loadButton.isHidden = isOn
        activityIndicator.isHidden = !isOn
        
        activityIndicator.isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
    
    @IBAction func loadJokes() {
        
        guard let unwrappedText = numberOfJokesTextField.text else {
            print("Заполните поле количества шуток")
            return
        }
        
        guard let _ = Int(unwrappedText) else {
            print("Введите корректное значение")
            return
        }
        
        toggleUI(true)
        
        networkManager.fetchJokes(numberOfJokes: unwrappedText) { [weak self]
            (information) in
            
            guard let information = information else { return }
            self?.receivedJokes = information.value
        }
    }

}

extension JokesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        receivedJokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JokeCell.reuseId) as! JokeCell
        let joke = receivedJokes[indexPath.row]
        cell.setupCell(with: joke)
        cell.applyAnimationForAppearing()
        return cell
    }
    
}
