//
//  FotoViewController.swift
//  day16
//
//  Created by Macbook Pro on 10/25/20.
//

import UIKit

class FotoViewController: UIViewController {

    @IBOutlet weak var fotoView: UIImageView!
    var fotoDetail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = fotoDetail
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let fotoDidLoad = fotoDetail {
            fotoView.image = UIImage(named: fotoDidLoad)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = fotoView.image?.jpegData(compressionQuality: 0.8) else {
            print("image not found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, "\(fotoDetail ?? "No Name")"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // for iPad
        present(vc, animated: true)
    }

}
