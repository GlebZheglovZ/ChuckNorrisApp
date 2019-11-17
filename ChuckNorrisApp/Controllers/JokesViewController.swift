//
//  ViewController.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 16.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit
import MessageUI

class JokesViewController: UIViewController {
    
    // MARK: - Class Properties
    
    var receivedJokes = [Joke]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.toggleUI(false)
            }
        }
    }
    
    let networkManager = NetworkManager()
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var numberOfJokesTextField: UITextField!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActivityIndicator()
    }
    
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
    
    // MARK: - @IBActions
    
    @IBAction func loadJokes() {
        
        guard inputValidation() else { return }
        guard let numberOfJokes = numberOfJokesTextField.text else { return }
        
        toggleUI(true)
        
        networkManager.fetchJokes(numberOfJokes: numberOfJokes) { [weak self]
            (information) in
            
            guard let information = information else {
                
                DispatchQueue.main.async {
                    self?.toggleUI(false)
                    self?.showAlertController(title: "Error", message: "Please try again later")
                    return
                }
                
                return
            }
            
            self?.receivedJokes = information.value
        }
    }
    
}

// MARK: - Extension (UITableViewDataSource/UITableViewDelegate)

extension JokesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        receivedJokes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JokeCell.reuseId) as! JokeCell
        let joke = receivedJokes[indexPath.row]
        cell.setupCell(with: joke)
        cell.applyAnimationForAppearing()
        return cell
    }
    
}

// MARK: - Extension (MFMailComposeViewControllerDelegate)

extension JokesViewController: MFMailComposeViewControllerDelegate {
    
    //Реализация вызова MFMailComposeViewController'а при нажатии на BarButtonItem
    
    @IBAction func reportAProblem() {
        
        if !MFMailComposeViewController.canSendMail() {
            showAlertController(title: "Error", message: "Please set up an email account \nto give feedback")
        } else {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Report a Bug/Feedback")
            mail.setToRecipients(["marvelheroes92@gmail.com"])
            mail.setMessageBody("<p>Hello!</p></p>I have a ...</p>", isHTML: true)
            present(mail, animated: true)
        }
    }
    
    //Выход из MFMailComposeViewController'а по завершению работы с ним
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
    
}
