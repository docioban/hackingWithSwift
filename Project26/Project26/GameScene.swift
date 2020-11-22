//
//  GameScene.swift
//  Project26
//
//  Created by Macbook Pro on 11/22/20.
//

import CoreMotion
import SpriteKit
import GameplayKit

enum CollisionType: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case portal = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var portalExit: SKSpriteNode!
    
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager!
    
    var isGameOver = false
    var level = 1
    var gameComponents = [SKSpriteNode]()
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        score = 0
        addChild(scoreLabel)
        
        loadLevel()
        createPlayer(CGPoint(x: 96, y: 672))
        
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
    }
    
    func loadLevel() {
        guard let pathURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Can not open this file level\(level).txt")
        }
        guard let pathString = try? String(contentsOf: pathURL) else {
            fatalError("Can n ot load file from path")
        }
        
        let lines = pathString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, char) in line.enumerated() {
                let position = CGPoint(x: column * 64 + 32, y: row * 64 - 32)
                if char == "x" {
                    createBlock(position)
                } else if char == "s" {
                    createStar(position)
                } else if char == "v" {
                    createVortex(position)
                } else if char == "f" {
                    createFinish(position)
                } else if char == "p" {
                    createPortal(position)
                } else if char == "P" {
                    createPortalExit(position)
                }
                else if char == " " {
                    // nothing
                } else {
                    fatalError("No such letter: \(char)")
                }
            }
        }
        physicsWorld.gravity = .zero
    }
    
    func createBlock(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
        gameComponents.append(node)
    }
    
    func createStar(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.position = position
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionType.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        addChild(node)
        gameComponents.append(node)
    }
        
    func createVortex(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionType.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        addChild(node)
        gameComponents.append(node)
    }
    
    func createFinish(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.position = position
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionType.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        node.physicsBody?.contactTestBitMask = 0
        node.physicsBody?.isDynamic = false
        addChild(node)
        gameComponents.append(node)
    }
    
    func createPlayer(_ poz: CGPoint) {
        player = SKSpriteNode(imageNamed: "player")
        player.name = "player"
        player.position = poz//CGPoint(x: 96, y: 672)
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionType.star.rawValue | CollisionType.finish.rawValue | CollisionType.vortex.rawValue | CollisionType.portal.rawValue
        player.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(player)
    }
    
    func createPortal(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "portal")
        node.size = CGSize(width: 64, height: 64)
        node.name = "portal"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionType.portal.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func createPortalExit(_ position: CGPoint) {
        portalExit = SKSpriteNode(imageNamed: "portalExit")
        portalExit.size = CGSize(width: 64, height: 64)
        portalExit.position = position
        portalExit.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        addChild(portalExit)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastTouchPosition = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastTouchPosition = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
            if let touchPosition = lastTouchPosition {
                let diff = CGPoint(x: touchPosition.x - player.position.x, y: touchPosition.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            }
        #else
            if let accelerometerData = motionManager.accelerometerData {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * 50, dy: accelerometerData.acceleration.x * -50)
            }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "player" {
            playerCollided(with: nodeB)
        } else if nodeB.name == "player" {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration: 0.4)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) {
                [weak self] in
                self?.isGameOver = false
                self?.createPlayer(CGPoint(x: 96, y: 672))
            }
        } else if node.name == "star" {
            score += 1
            node.removeFromParent()
        } else if node.name == "finish" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration: 0.4)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            level+=1
            player.run(sequence) {
                [weak self] in
                self?.gameComponents.forEach({$0.removeFromParent()})
                self?.loadLevel()
                self?.createPlayer(CGPoint(x: 96, y: 672))
                self?.isGameOver = false
            }
        } else if node.name == "portal" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration: 0.4)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) {
                [weak self] in
                self?.createPlayer(self?.portalExit.position ?? CGPoint(x: 96, y: 672))
                self?.isGameOver = false
            }
        }
    }
}
