//
//  WebPageVC.swift
//  Formula1
//
//  Created by Daniil Kim on 02.06.2021.
//

import UIKit
import WebKit

class WebPageVC: UIViewController {
    
    // MARK: - Properties
    
    var url: URL
    
    // MARK: - Initializers
    
    required init(show url: URL) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Private Methods
    
    private func setupWebView() {
        let webView = WKWebView(frame: view.frame)
        view.addSubview(webView)
        
        let request = URLRequest(url: url)
        DispatchQueue.main.async {
            webView.load(request)
        }
    }
    
}
