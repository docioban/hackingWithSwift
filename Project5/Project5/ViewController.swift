//
//  ViewController.swift
//  Project5
//
//  Created by Macbook Pro on 10/28/20.
//

import UIKit

class ViewController: UITableViewController {

    var words = [String]()
    var wordsUsed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                words = startWords.components(separatedBy: "\n")
            }
        }
        if words.isEmpty {
            words = ["Empty"]
        }
        
        title = words.randomElement()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
    }
    
    @objc func addAnswer() {
        let ac = UIAlertController(title: "Answer", message: "", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            guard let answerd = ac?.textFields?[0].text else { return }
            self?.submit(answerd)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func startGame() {
        title = words.randomElement()
        wordsUsed.removeAll()
        tableView.reloadData()
    }
    
    func submit(_ answerd: String) {
        let lowerAnswerd = answerd.lowercased()
        if isPossible(lowerAnswerd) {
            if isOriginal(lowerAnswerd) {
                if isReal(lowerAnswerd) {
                    wordsUsed.insert(lowerAnswerd, at: 0)
                    let indexInsert = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexInsert], with: .automatic)
                } else {
                    makeAlert(tit: "No such word", mes: "This not is english word")
                }
            } else {
                makeAlert(tit: "Word used already", mes: "By more original")
            }
        } else {
            makeAlert(tit: "Is not possible word", mes: "You can't spell this word from \(title!)")
        }
    }
    
    func isPossible(_ answerd: String) -> Bool {
        guard var word = title?.lowercased() else { return false }
        if word.hasPrefix(answerd) {
            return false
        }
        for letter in answerd {
            if let possition = word.firstIndex(of: letter) {
                word.remove(at: possition)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(_ answerd: String) -> Bool {
        return !wordsUsed.contains(answerd)
    }
    
    func isReal(_ answerd: String) -> Bool {
        if answerd.count < 3 {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: answerd.utf16.count)
        let misspledRange = checker.rangeOfMisspelledWord(in: answerd, range: range, startingAt: 0, wrap: false, language: "en")
        return misspledRange.location == NSNotFound
    }
    
    func makeAlert(tit: String, mes: String) {
        let ac = UIAlertController(title: tit, message: mes, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsUsed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellWord", for: indexPath)
        cell.textLabel?.text = wordsUsed[indexPath.row]
        return cell
    }

}

