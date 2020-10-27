//
//  ViewController.swift
//  Project4
//
//  Created by Macbook Pro on 10/26/20.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var progresView: UIProgressView!
    var webView: WKWebView!
    var uploadIndex: Int?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let indexSite = uploadIndex else {
            print("Error, no index uploaded")
            return
        }
        let url = URL(string: "https://www.\(sites[indexSite])")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "open", style: .plain, target: self, action: #selector(chooseTap))
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(goBack))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .plain, target: self, action: #selector(goForward))
        progresView = UIProgressView(progressViewStyle: .default)
//        progresView.sizeToFit()
        let progresButton = UIBarButtonItem(customView: progresView)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        let spacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [backButton, forwardButton, progresButton, spacing, reload]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func goBack() {
        webView.goBack()
    }
    
    @objc func goForward() {
        webView.goForward()
    }
    
    @objc func chooseTap() {
        let ac = UIAlertController(title: "Choose web", message: nil, preferredStyle: .actionSheet)
        for site in sites {
            ac.addAction(UIAlertAction(title: site, style: .default, handler: openWeb))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openWeb(alert: UIAlertAction) {
        let url = URL(string: "https://\(alert.title!)")!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progresView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for site in sites {
                if host.contains(site) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
//        let ac = UIAlertController(title: "No such site", message: "return back", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(ac, animated: true)
        decisionHandler(.cancel)
    }

}

