//
//  DetailViewController.swift
//  Project1-2
//
//  Created by Macbook Pro on 10/26/20.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var nameSend: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = nameSend
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))

        if let titleImage = nameSend {
            imageView.image = UIImage(named: titleImage)
        }
    }
    
    @objc func shareImage() {
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.9) else {
            print("No such foto")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, nameSend!], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // for iPad
        present(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
