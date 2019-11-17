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
        setupTextField()
        addKeyboardObservers()
        setupActivityIndicator()
        
        networkManager.fetchJokes(numberOfJokes: "1") { [weak self]
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
    
    deinit {
        removeKeyboardObservers()
    }
    
    // MARK: - @IBActions
    
    @IBAction func loadJokes() {
        
        guard inputValidation() else { return }
        guard let numberOfJokes = numberOfJokesTextField.text else { return }
        
        if !Reachability.checkInternetActivity() {
            showAlertController(title: "Error", message: "Check your Internet Connection")
            return
        }
        
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
    
}

// MARK: - Extension (UITextFieldDelegate)

extension JokesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 4
    }
    
}
