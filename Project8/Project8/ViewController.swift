//
//  ViewController.swift
//  Project8
//
//  Created by Macbook Pro on 10/30/20.
//

import UIKit

class ViewController: UIViewController {

    let currentAnswerd = UITextField()
    let resultLabel = UILabel()
    let scoreLabel = UILabel()
    
    var textButtons = [String]()
    var questions = [String]()
    var answerds = [String]()
    var answerdWords = [String]()
    var buttonTapped = [UIButton]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score = \(score)"
        }
    }
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFile()
//        loadLevel()
    }
    
    func loadLevel() {
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score = \(score)"
        view.addSubview(scoreLabel)
        
        let questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.numberOfLines = 0
        questionLabel.text = "Questions\n\(questions.joined(separator: "\n"))"
        questionLabel.font = questionLabel.font.withSize(24)
        view.addSubview(questionLabel)
        questionLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)

        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.numberOfLines = 0
        resultLabel.text = "Rezults\n\(answerds.joined(separator: "\n"))"
        resultLabel.font = resultLabel.font.withSize(24)
        resultLabel.textAlignment = .right
        view.addSubview(resultLabel)
        resultLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswerd.translatesAutoresizingMaskIntoConstraints = false
        currentAnswerd.isUserInteractionEnabled = false
        currentAnswerd.textColor = .gray
        currentAnswerd.placeholder = "Type answerd"
        currentAnswerd.textAlignment = .center
        currentAnswerd.font = currentAnswerd.font?.withSize(40)
        view.addSubview(currentAnswerd)
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.black.cgColor
        view.addSubview(submitButton)
        
        let clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        clearButton.layer.borderWidth = 1
        clearButton.layer.borderColor = UIColor.black.cgColor
        view.addSubview(clearButton)
        
        let answerdButtons = UIView()
        answerdButtons.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answerdButtons)
        
        
        let constraints = [
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            questionLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6, constant: -100),
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            questionLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            
            resultLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4, constant: -100),
            resultLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
            resultLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            resultLabel.heightAnchor.constraint(equalTo: questionLabel.heightAnchor),
            
            currentAnswerd.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswerd.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            
            submitButton.topAnchor.constraint(equalTo: currentAnswerd.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -50),
            submitButton.widthAnchor.constraint(equalToConstant: 80),
            
            clearButton.topAnchor.constraint(equalTo: currentAnswerd.bottomAnchor, constant: 20),
            clearButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 50),
            clearButton.widthAnchor.constraint(equalToConstant: 80),
            
            answerdButtons.widthAnchor.constraint(equalToConstant: 750),
            answerdButtons.heightAnchor.constraint(equalToConstant: 320),
            answerdButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            answerdButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerdButtons.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 30)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        
        let width = 150
        let height = 80
        
        if textButtons.count == 20 {
            for row in 0..<4 {
                for col in 0..<5 {
                    let button = UIButton(type: .system)
                    
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                    button.setTitle(textButtons[row*5+col], for: .normal)
                    
                    let frame = CGRect(x: col*width, y: row*height, width: width, height: height)
                    button.frame = frame
                    button.addTarget(self, action: #selector(addButtonText), for: .touchUpInside)
                    button.layer.borderColor = UIColor.blue.cgColor
                    button.layer.borderWidth = 0.7
                    answerdButtons.addSubview(button)
                }
            }
        }
    }
    
    @objc func submit() {
        guard let word = currentAnswerd.text else { return }
        if let index = answerdWords.firstIndex(of: word) {
            buttonTapped.removeAll()
            answerds[index] = word
            resultLabel.text = "Rezults\n\(answerds.joined(separator: "\n"))"
            currentAnswerd.text = ""
            score += 1
            if score % 7 == 0 {
                level = 2
                loadLevel()
            }
        } else {
            let ac = UIAlertController(title: "Wrong", message: "No such answerd", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func clear() {
        for button in buttonTapped {
            button.isHidden = false
        }
        currentAnswerd.text = ""
    }
    
    @objc func addButtonText(sender: UIButton!) {
        currentAnswerd.text?.append((sender.titleLabel?.text)!)
        buttonTapped.append(sender)
        sender.isHidden = true
    }
    
    func readFile() {
        answerds.removeAll()
        questions.removeAll()
        textButtons.removeAll()
        answerdWords.removeAll()
        DispatchQueue.global(qos: .userInteractive).async {
            [unowned self] in
            if let urlFile = Bundle.main.url(forResource: "level\(self.level)", withExtension: ".txt") {
                if let bodyFile = try? String(contentsOf: urlFile) {
                    var lines = bodyFile.components(separatedBy: "\n")
                    lines.shuffle()
                    for (index, line) in lines.enumerated() {
                        let partions = line.components(separatedBy: ": ")
                        self.questions.append("\(index+1). "+partions[1])
                        self.textButtons.append(contentsOf: partions[0].components(separatedBy: "|"))
                        self.answerdWords.append(partions[0].replacingOccurrences(of: "|", with: ""))
                        self.answerds.append("\(self.answerdWords.last!.count) characters")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    [weak self] in
                    let ac = UIAlertController(title: "No such file", message: "Can't open this file", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(ac, animated: true)
                }
            }
            print(self.answerds)
            self.textButtons.shuffle()
            DispatchQueue.main.async {
                [weak self] in
                self?.loadLevel()
            }
        }
    }
}

