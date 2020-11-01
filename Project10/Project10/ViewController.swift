//
//  ViewController.swift
//  Project10
//
//  Created by Macbook Pro on 11/1/20.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(choseAction))
    }
    
    @objc func choseAction() {
        let ac = UIAlertController(title: "Chose", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Galary", style: .default) {
            _ in
            self.addCollection(i: 1) // galary
        })
        ac.addAction(UIAlertAction(title: "Camera", style: .default) {
            _ in
            self.addCollection(i: 2) // camera
        })
        present(ac, animated: true)
    }
    
    func addCollection(i: Int) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if i == 2 {
            picker.sourceType = .camera
            picker.allowsEditing = false
        } else {
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jsonData = image.jpegData(compressionQuality: 0.8) {
            try? jsonData.write(to: imagePath)
        }
        
        var name = ""
        
        let ac = UIAlertController(title: "Name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            name = text
            self.people.append(Person(name: name, image: imageName))
            self.collectionView.reloadData()
        })
        
        dismiss(animated: true)
        present(ac, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PersonCollectionViewCell else { fatalError("Unabel de dequeue PersonCollectionViewCell") }
        
        cell.nameLabel.text = people[indexPath.item].name
        
        let path = getDocumentsDirectory().appendingPathComponent(people[indexPath.item].image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.cornerRadius = 5
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.6).cgColor
        cell.layer.cornerRadius = 7
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ac = UIAlertController(title: people[indexPath.item].name, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .cancel) {
            [weak self] _ in
            self?.people.remove(at: indexPath.item)
            collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Rename", style: .default){
            [weak self] _ in
            let ac = UIAlertController(title: "Chenge Name", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Chenge", style: .default) {
                [weak self, weak ac] _ in
                guard let name = ac?.textFields?[0].text else { return }
                self?.people[indexPath.item].name = name
                collectionView.reloadData()
            })
    
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac, animated: true)
        })
        present(ac, animated: true)
        print("sdags")
    }

}

