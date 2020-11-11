//
//  GameScene.swift
//  Project16-18
//
//  Created by Macbook Pro on 11/9/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var shoots = [FotoShoot]()
    var bullets = [SKSpriteNode]()
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: "
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        createShoot(at: CGPoint(x: 200, y: 340), size: CGSize(width: 100, height: 100), points: 40, speed: 0.5)
        createShoot(at: CGPoint(x: 200, y: 500), size: CGSize(width: 90, height: 90), points: 50, speed: 0.6)
        createShoot(at: CGPoint(x: 200, y: 660), size: CGSize(width: 80, height: 80), points: 60, speed: 0.7)
        createShoot(at: CGPoint(x: 512, y: 180), size: CGSize(width: 110, height: 110), points: 30, speed: 0.4)
        createShoot(at: CGPoint(x: 800, y: 340), size: CGSize(width: 100, height: 100), points: 40, speed: 0.5)
        createShoot(at: CGPoint(x: 800, y: 500), size: CGSize(width: 90, height: 90), points: 50, speed: 0.6)
        createShoot(at: CGPoint(x: 800, y: 660), size: CGSize(width: 80, height: 80), points: 60, speed: 0.7)
        
        for i in 0..<5 {
            createBullet(at: CGPoint(x: 450 + i*30, y: 700))
        }
        
    }
    
    func createShoot(at pos: CGPoint, size: CGSize, points: Int, speed: Double) {
        let shoot = FotoShoot()
        shoot.configure(at: pos, size: size, points: points, speed: speed)
        shoot.show()
        addChild(shoot)
        shoots.append(shoot)
    }
    
    func createBullet(at pos: CGPoint) {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position = pos
        bullet.size = CGSize(width: 30, height: 80)
        addChild(bullet)
        bullets.append(bullet)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        for node in tappedNodes {
            guard let fotoShoot = node.parent as? FotoShoot else {
                continue
            }
            fotoShoot.hit()
            score += fotoShoot.points
            print(score)
            return
        }
        score -= 10
        if bullets.isEmpty {
            gameOver()
            return
        }
        bullets.last?.removeFromParent()
        bullets.removeLast()
    }
    
    func gameOver() {
        shoots.forEach({$0.hit()})
        let text = SKLabelNode(fontNamed: "Chalkduster")
        text.text = "GAME OVER!"
        text.fontSize = 50
        text.position = CGPoint(x: 512, y: 384)
        addChild(text)
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
