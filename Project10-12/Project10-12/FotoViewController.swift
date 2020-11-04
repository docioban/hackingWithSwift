//
//  FotoViewController.swift
//  Project10-12
//
//  Created by Macbook Pro on 11/3/20.
//

import UIKit

class FotoViewController: UIViewController {

    @IBOutlet weak var fotoView: UIImageView!
    var imageName: String?
    var imagePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = imagePath else {
            return
        }
        title = imageName != nil ? imageName : ""
        
        let path = getDocument().appendingPathComponent(image)
        fotoView.image = UIImage(contentsOfFile: path.path)
    }
    
    func getDocument() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
