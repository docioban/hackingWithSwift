//
//  ViewController.swift
//  Project2
//
//  Created by Macbook Pro on 10/25/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    var countries = [String]()
    var score = 0
    var correctVariant = 0
    var numberOfQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctVariant = Int.random(in: 0...2)
        
        title = countries[correctVariant].uppercased()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(score), style: .plain, target: self, action: #selector(scoreTap))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    @objc func scoreTap() {
        let ac = UIAlertController(title: "Score", message: String(score), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(ac, animated: true)
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        var title: String
        var message = ""

        if sender.tag == correctVariant {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
            message = "Correct answer is flag number \(correctVariant+1)\n"
        }
        message += "Your score is \(score)"
        
        if numberOfQuestions == 10 {
            title = score < 5 ? "Game Over" : "Win!!!"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: askQuestion))
            present(ac, animated: true)
            return
        }
        numberOfQuestions += 1

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
}

