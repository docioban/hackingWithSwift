//
//  ViewController.swift
//  Project25-27
//
//  Created by Macbook Pro on 11/24/20.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    var topText: String?
    var bottomText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        let topButton = UIBarButtonItem(title: "Top", style: .plain, target: self, action: #selector(addTopText))
        let bottomButton = UIBarButtonItem(title: "Bottom", style: .plain, target: self, action: #selector(addBottomText))
        navigationItem.leftBarButtonItems = [topButton, bottomButton]
    }
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.9) {
            try? jpegData.write(to: imagePath)
        }
        imageView.image = UIImage(contentsOfFile: imagePath.path)
        self.image = imageView.image
        dismiss(animated: true)
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage)))
//        UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    @objc func shareImage() {
        let ac = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        present(ac, animated: true)
        
    }
    
    @objc func addTopText() {
        let ac = UIAlertController(title: "Top text", message: nil, preferredStyle: .alert)
        ac.addTextField() {
            text in
            text.placeholder = "Enter something"
        }
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak self] _ in
            if let textFields = ac.textFields{
                let theTextFields = textFields as [UITextField]
                let enteredText = theTextFields[0].text
                self?.topText = enteredText ?? ""
            }
            self?.addText(topText: self?.topText, bottomText: self?.bottomText)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    @objc func addBottomText() {
        
        let ac = UIAlertController(title: "Top text", message: nil, preferredStyle: .alert)
        ac.addTextField() {
            text in
            text.placeholder = "Enter something"
        }
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak self] _ in
            if let textFields = ac.textFields{
                let theTextFields = textFields as [UITextField]
                let enteredText = theTextFields[0].text
                self?.bottomText = enteredText ?? ""
            }
            self?.addText(topText: self?.topText, bottomText: self?.bottomText)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    func addText(topText top: String?, bottomText bot: String?) {
        guard let image = imageView.image else {
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: image.size.width, height: image.size.height))
        
        let img = renderer.image {
            ctx in
            
            self.image?.draw(at: CGPoint(x: 0, y: 0))
            
            if top != nil {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 60),
                    .paragraphStyle: paragraphStyle,
                    .backgroundColor: UIColor.white,
                    .strokeColor: UIColor.black
                ]
                
                let atributeString = NSAttributedString(string: top!, attributes: attrs)
                
                atributeString.draw(with: CGRect(x: 0, y: 50, width: image.size.width, height: 200), options: .usesLineFragmentOrigin, context: nil)
            }
            
            if bot != nil {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 60),
                    .paragraphStyle: paragraphStyle,
                    .backgroundColor: UIColor.white,
                    .strokeColor: UIColor.black
                ]
                
                let atributeString = NSAttributedString(string: bot!, attributes: attrs)
                
                atributeString.draw(with: CGRect(x: 0, y: image.size.height - 100, width: image.size.width, height: 200), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        imageView.image = img
    }


}

