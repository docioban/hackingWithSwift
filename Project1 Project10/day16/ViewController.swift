//
//  ViewController.swift
//  day16
//
//  Created by Macbook Pro on 10/25/20.
//

import UIKit

class ViewController: UICollectionViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pictures"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)

            for item in items {
                if item.hasSuffix(".jpg") {
                    self?.pictures.append(item)
                }
            }
            DispatchQueue.main.async {
                [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cel = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FotoCollectionViewCell else {
            fatalError("Can not dequeue as FotoCollectionViewCell")
        }
        cel.name.text = pictures[indexPath.item]
        cel.image.image = UIImage(named: pictures[indexPath.item])
        return cel
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "foto") as? FotoViewController {
            vc.fotoDetail = pictures[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

