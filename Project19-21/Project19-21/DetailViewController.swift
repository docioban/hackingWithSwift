//
//  DetailViewController.swift
//  Project19-21
//
//  Created by Macbook Pro on 11/15/20.
//

import UIKit

class DetailViewController: UIViewController {

    var index = 0
    var del = false
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if index != notes.count {
            titleLabel.text = notes[index].title
            bodyLabel.text = notes[index].body
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareInfo))
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func shareInfo() {
        let vc = UIActivityViewController(activityItems: [titleLabel.text ?? "", bodyLabel.text ?? ""], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func adjustKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            bodyLabel.contentInset = .zero
        } else {
            bodyLabel.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        bodyLabel.scrollIndicatorInsets = bodyLabel.contentInset
        
        let selectRange = bodyLabel.selectedRange
        bodyLabel.scrollRangeToVisible(selectRange)
    }

    @IBAction func deleteNote(_ sender: Any) {
        let ac = UIAlertController(title: "Delete", message: "You are sure that you wont delete?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive) {_ in
            notes.remove(at: self.index)
            self.navigationController?.popViewController(animated: true)
            self.del = true
        })
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard !del else {
            return
        }
        if index == notes.count { // create new
            let note = Note(title: titleLabel.text ?? "", body: bodyLabel.text)
            notes.append(note)
        } else {
            notes[index].title = titleLabel.text ?? ""
            notes[index].body = bodyLabel.text
        }
    }
}

