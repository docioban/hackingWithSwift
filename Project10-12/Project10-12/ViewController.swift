//
//  ViewController.swift
//  Project10-12
//
//  Created by Macbook Pro on 11/3/20.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var titlePhoto = [String]()
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let dataSaved = defaults.object(forKey: "photos") as? Data {
            let decoder = JSONDecoder()
            do {
                pictures = try decoder.decode([Picture].self, from: dataSaved)
            } catch {
                print("Data can not decode")
            }
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoTap))
    }
    
    @objc func addPhotoTap() {
        let ac = UIAlertController(title: "From", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Galary", style: .default){
            [weak self] _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Camera", style: .default))
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let imageName = UUID().uuidString
        let imagePath = getDocument().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let ac = UIAlertController(title: "Name", message: "Nume of file", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default){
            [weak self, weak ac] _ in
            if let textField = ac?.textFields?[0] {
                self?.pictures.append(Picture(fileName: imageName, caption: textField.text ?? "No text"))
                self?.save()
                self?.tableView.reloadData()
            }
        })
        dismiss(animated: true)
        present(ac, animated: true)
    }
    
    func getDocument() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "FotoDetail") as? FotoViewController {
            vc.imageName = pictures[indexPath.row].caption
            vc.imagePath = pictures[indexPath.row].fileName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let dataSave = try? encoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(dataSave, forKey: "photos")
        }
    }

}

