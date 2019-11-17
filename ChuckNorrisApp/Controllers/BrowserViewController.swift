//
//  BrowserViewController.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 17.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAPIDocs()
    }
    
    func loadAPIDocs() {
        guard let url = URL(string: "http://www.icndb.com/api/") else { return }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
}
