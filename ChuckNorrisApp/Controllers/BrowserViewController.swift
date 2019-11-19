//
//  BrowserViewController.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 17.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupWebView()
        loadAPIDocs()
    }
    
    // MARK: - UI Setup Methods
    func setupWebView() {
        webView.delegate = self
        webView.scalesPageToFit = true
    }
    
    func setupActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    func setupUI() {
        setupWebView()
        setupActivityIndicator()
    }
    
    // MARK: - Actions Methods
    func toggleUI(_ isOn: Bool) {
        self.webView.isHidden = isOn
        self.activityIndicator.isHidden = !isOn
        isOn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func loadAPIDocs() {
        guard let url = URL(string: "http://www.icndb.com/api/") else { return }
        toggleUI(true)
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
}

// MARK: - Extension (UIWebViewDelegate)
extension BrowserViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        toggleUI(false)
    }
    
}
