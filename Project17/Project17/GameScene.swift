//
//  GameScene.swift
//  Project17
//
//  Created by Macbook Pro on 11/8/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var player: SKSpriteNode!
    var starEmitter: SKEmitterNode!
    
    let possibleEnemy = ["hammer", "tv", "ball"]
    var timer: Timer?
    var isGameOver = false
    var isTouch = false
    var timeBeetwinEnemy = 1.0
    var numberOfEnemy = 0 {
        didSet {
            if numberOfEnemy > 20 {
                timer?.invalidate()
                numberOfEnemy = 0
                timeBeetwinEnemy -= 0.1
                timer = Timer.scheduledTimer(timeInterval: timeBeetwinEnemy, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            }
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starEmitter = SKEmitterNode(fileNamed: "starfield")!
        starEmitter.position = CGPoint(x: 1024, y: 384)
        starEmitter.advanceSimulationTime(10)
        addChild(starEmitter)
        starEmitter.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        timer = Timer.scheduledTimer(timeInterval: timeBeetwinEnemy, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        guard let nameEnemy = possibleEnemy.randomElement() else {
            return
        }
        let enemy = SKSpriteNode(imageNamed: nameEnemy)
        enemy.position = CGPoint(x: 1200, y: Int.random(in: 50...750))
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemy.physicsBody?.categoryBitMask = 1
        enemy.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        enemy.physicsBody?.angularVelocity = 4
        enemy.physicsBody?.linearDamping = 0
        enemy.physicsBody?.angularDamping = 0
        addChild(enemy)
        numberOfEnemy+=1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let poz = touch.location(in: self)
        if player.contains(poz) {
            isTouch = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouch {
            guard let touch = touches.first else {
                return
            }
            var location = touch.location(in: self)
            
            if location.y > 670 {
                location.y = 700
            }
            if location.y < 50 {
                location.y = 50
            }
            player.position = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouch = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
        timer?.invalidate()
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
}
