//
//  ViewController.swift
//  Project7-9
//
//  Created by Macbook Pro on 10/31/20.
//

import UIKit

class ViewController: UIViewController {
    
    let viewButtons = UIView()
    let actualAnswrd = UILabel()
    let scoreLabel = UILabel()

    let charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var words = [String]()
    var word = ""
    var nrLetter = 0
    var letters = [Character]()
    var lettersButton = [UIButton]()
    var actualChars = [Character]()
    
    var score = 7 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFile()
        loadLevel()
    }
    
    func loadLevel() {
        score = 7
        word = words.randomElement()!
        nrLetter = word.count
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = scoreLabel.font.withSize(20)
        view.addSubview(scoreLabel)
        
        actualAnswrd.translatesAutoresizingMaskIntoConstraints = false
        actualAnswrd.text = ""
        for _ in 0..<nrLetter {
            actualAnswrd.text! += "?"
            actualChars.append("?")
        }
        actualAnswrd.font = actualAnswrd.font.withSize(36)
        view.addSubview(actualAnswrd)
    
        viewButtons.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewButtons)
        
        
        NSLayoutConstraint.activate([
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            actualAnswrd.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actualAnswrd.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            viewButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            viewButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewButtons.heightAnchor.constraint(equalToConstant: 440),
            viewButtons.widthAnchor.constraint(equalToConstant: 360)
        ])
        
        letters = Array(word)
        for _ in 0..<16-nrLetter {
            letters.append(charSet.randomElement()!)
        }
        letters.shuffle()
        
        for (index, char) in letters.enumerated() {
            let button = UIButton(type: .system)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
            button.setTitle("\(char)", for: .normal)
            let frame = CGRect(x: index%4*90, y: index/4*110, width: 90, height: 110)
            button.frame = frame
            button.backgroundColor = .green
            button.tag = index
            button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
            viewButtons.addSubview(button)
            lettersButton.append(button)
        }
    }
    
    @objc func buttonTap(sender: UIButton!) {
        let letter = letters[sender.tag]
        if word.contains(letter) {
            for (index, char) in word.enumerated() {
                if char == letter {
                    actualChars[index] = char
                }
            }
            actualAnswrd.text? = String(actualChars)
            for button in lettersButton {
                if button.titleLabel?.text == "\(letter)" {
                    button.isHidden = true
                }
            }
            if !actualChars.contains("?") {
                let ac = UIAlertController(title: "You win!!", message: "congratulations", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Next Level", style: .default, handler: levelUp))
                present(ac, animated: true)
                
            }
        } else {
            if score == 0 {
                let ac = UIAlertController(title: "Lose", message: "You lose\nThe corect answerd is \(word)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: levelUp))
                present(ac, animated: true)
                
            } else {
                score -= 1
                let ac = UIAlertController(title: "Wrong", message: "No such letter in word", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        viewButtons.subviews.forEach({$0.removeFromSuperview()})
        letters = [Character]()
        lettersButton = [UIButton]()
        actualChars = [Character]()
        loadLevel()
    }

    func readFile() {
        if let urlString = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            if let contents = try? String(contentsOf: urlString) {
                words = contents.components(separatedBy: "\n")
            }
        }
    }

}

