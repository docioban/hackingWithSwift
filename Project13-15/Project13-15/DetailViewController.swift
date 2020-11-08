//
//  DetailViewController.swift
//  Project13-15
//
//  Created by Macbook Pro on 11/8/20.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var detail: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detail = detail else {
            return
        }
        
        title = detail.nameCountry
        
        nameLabel.text = detail.nameCapital
        sizeLabel.text = detail.size
        populationLabel.text = String(detail.population)
        currencyLabel.text = detail.currency
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareInfo))
    }

    @objc func shareInfo() {
        guard let detail = detail else {
            return
        }
        let text = [ """
        Name Country: \(detail.nameCapital)\n
        Name Catipat: \(detail.nameCapital)\n
        Size: \(detail.size)\n
        Population: \(detail.population)\n
        Curency: \(detail.currency)
        """ ]
        let activityViewController = UIActivityViewController(activityItems: text, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // for ipad
        present(activityViewController, animated: true)
    }
}
