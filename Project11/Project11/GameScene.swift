//
//  GameScene.swift
//  Project11
//
//  Created by Macbook Pro on 11/1/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var editingLabel: SKLabelNode!
    
    var liveCircles = [SKShapeNode]()
    
    var lives = 4
    var ballName = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
    var isEditing = false {
        didSet {
            editingLabel.text = isEditing ? "Done" : "Edit"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score \(score)"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 720)
        addChild(scoreLabel)
        
        editingLabel = SKLabelNode(fontNamed: "Chalkduster")
        editingLabel.text = "Edit"
        editingLabel.position = CGPoint(x: 40, y: 720)
        addChild(editingLabel)
        
        for i in 0...4 {
            liveCircles.append(SKShapeNode(circleOfRadius: 20))
            liveCircles[i].position = CGPoint(x: 200+i*60, y: 725)
            liveCircles[i].fillColor = SKColor.white
            addChild(liveCircles[i])
        }
        
        physicsWorld.contactDelegate = self
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        for i in 0..<5 {
            makeBouncer(at: CGPoint(x: i*256, y: 0))
        }
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
    }
    
    func makeBouncer(at poz: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = poz
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at poz: CGPoint, isGood good: Bool) {
        let base = SKSpriteNode(imageNamed: good ? "slotBaseGood" : "slotBaseBad")
        let glow = SKSpriteNode(imageNamed: good ? "slotGlowGood" : "slotGlowBad")
        base.name = good ? "good" : "bad"
        base.position = poz
        base.physicsBody = SKPhysicsBody(rectangleOf: base.size)
        base.physicsBody?.isDynamic = false
        
        glow.position = poz
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        glow.run(spinForever)
        
        addChild(glow)
        addChild(base)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = touches.first {
            
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
            
            if objects.contains(editingLabel) {
                isEditing.toggle() // isEditing = !isEditing
            } else {
                if isEditing {
                    let rect = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: CGSize(width: Int.random(in: 6...16), height: Int.random(in: 10...100)))
                    rect.zRotation = CGFloat.random(in: 0...3.14)
                    rect.physicsBody = SKPhysicsBody(rectangleOf: rect.size)
                    rect.physicsBody?.isDynamic = false
                    rect.position = location
                    rect.name = "rect"
                    addChild(rect)
                } else {
                    if lives < 0 {
                        gameOver()
                        return
                    } else {
                        liveCircles[lives].fillColor = SKColor.clear
                        lives -= 1
                    }
                    let circle = SKSpriteNode(imageNamed: ballName[Int.random(in: 0..<ballName.count)])
                    circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width / 2)
                    circle.physicsBody?.restitution = 0.4
                    circle.position.x = location.x
                    circle.position.y = 700
                    circle.name = "ball"
                    circle.physicsBody?.contactTestBitMask = circle.physicsBody!.collisionBitMask
                    addChild(circle)
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let objA = contact.bodyA.node else {
            return
        }
        guard let objB = contact.bodyB.node else {
            return
        }
        if objA.name == "ball" {
            collisionBetween(ball: objA, object: objB)
        } else if objB.name == "ball" {
            collisionBetween(ball: objB, object: objA)
        }
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            score += 1
            destroy(ball: ball)
            if lives < 4 {
                lives += 1
                liveCircles[lives].fillColor = SKColor.white
            }
        } else if object.name == "bad" {
            score -= 1
            destroy(ball: ball)
        } else if object.name == "rect" {
            destroy(object: object)
        }
    }
    
    func gameOver() {
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        let animation = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(newScene, transition: animation)
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles.sks") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func destroy(object: SKNode) {
        object.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
