//
//  WebViewController.swift
//  Project16
//
//  Created by Macbook Pro on 11/8/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView : WKWebView!
    var nameCity = ""
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = nameCity
        
        let url = URL(string: "https://en.wikipedia.org/wiki/\(nameCity)")
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
        
        // Do any additional setup after loading the view.
    }

}
