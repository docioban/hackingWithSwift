//
//  GameViewController.swift
//  Project29
//
//  Created by Macbook Pro on 11/27/20.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentGame: GameScene!
 
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        angleSliderChenged(angleSlider!)
        velocitySliderChanged(velocitySlider!)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleSliderChenged(_ sender: Any) {
        angleLabel.text = "Angle: \(angleSlider.value)°"
    }
    
    @IBAction func velocitySliderChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(velocitySlider.value)"
    }
    
    @IBAction func launchButtonTapped(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        player1Score.isHidden = true
        player2Score.isHidden = true
        
        launchButton.isHidden = true
        currentGame?.louch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int, score1: Int, score2: Int) {
        if number == 1 {
            playerLabel.text = "<<< Player1"
        } else {
            playerLabel.text = "Player2 >>>"
        }
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        
        player1Score.text = "\(score1)"
        player1Score.isHidden = false
        
        player2Score.text = "\(score2)"
        player2Score.isHidden = false
        
        
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        
        launchButton.isHidden = false
    }
}
