//
//  ViewController.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 16.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

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
    
    let coreDataContainer = AppDelegate.сontainer
    let networkManager = NetworkManager()
    
    // MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var numberOfJokesTextField: UITextField!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addKeyboardObservers()
        loadJokesFromDB()
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    // MARK: - UI
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
        numberOfJokesTextField.textAlignment = .center
        numberOfJokesTextField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        numberOfJokesTextField.font = UIFont.boldSystemFont(ofSize: 17)
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
    
    // MARK: - Observers
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Fetch Requests
    func fetchJokesFromAPI(numberOfJokes: String) {
        networkManager.fetchJokes(numberOfJokes: numberOfJokes) { [weak self] (information) in
            guard let information = information else {
                DispatchQueue.main.async {
                    self?.toggleUI(false)
                    self?.showAlertController(title: "Error", message: "Please try again later")
                    return
                }
                return
            }
            self?.receivedJokes = information.value
            self?.addJokesToDB(information.value)
        }
    }
    
    // MARK: - Core Data
    func addJokesToDB(_ jokes: [Joke]) {
        let request: NSFetchRequest<JokeEntity> = JokeEntity.fetchRequest()
        guard let jokeEntities = try? coreDataContainer.viewContext.fetch(request) else { return }
        
        if !jokeEntities.isEmpty {
            jokeEntities.forEach { (jokeEntity) in
                coreDataContainer.viewContext.delete(jokeEntity)
            }
        }
        
        jokes.forEach { (joke) in
            let jokeEntity = JokeEntity(context: coreDataContainer.viewContext)
            jokeEntity.joke = joke.joke
        }
    }
    
    func loadJokesFromDB() {
        let request: NSFetchRequest<JokeEntity> = JokeEntity.fetchRequest()
        var jokes = [Joke]()
        guard let jokeEntities = try? coreDataContainer.viewContext.fetch(request) else { return }
        if !jokeEntities.isEmpty {
            jokeEntities.forEach { (jokeEntity) in
                let joke = Joke(joke: jokeEntity.joke ?? "")
                jokes.append(joke)
            }
            receivedJokes = jokes
        }
    }
    
    // MARK: - @IBActions
    @IBAction func loadJokes() {
        numberOfJokesTextField.resignFirstResponder()
        guard inputValidation() else { return }
        guard let numberOfJokes = numberOfJokesTextField.text else { return }
        toggleUI(true)
        fetchJokesFromAPI(numberOfJokes: numberOfJokes)
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
    
    @objc func doneClicked() {
        view.endEditing(true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: JokeCell.reuseId, for: indexPath) as! JokeCell
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
