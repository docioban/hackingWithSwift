//
//  DatailViewController.swift
//  Project7
//
//  Created by Macbook Pro on 10/29/20.
//

import UIKit
import WebKit

class DatailViewController: UIViewController {

    var result: Result?
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let result = result else {
            return
        }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        <b>
        \(result.title)<br><br>
        </b>
        \(result.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
        
        
    }
}
