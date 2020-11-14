//
//  GameScene.swift
//  Project20
//
//  Created by Macbook Pro on 11/13/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var scoreLabel: SKLabelNode!
    
    let leftRange = -22
    let bottomRange = -22
    let rightRange = 1046
    let numberOfLevels = 10
    var numberOfLevelsWas = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 364)
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 70
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(makeFireworks), userInfo: nil, repeats: true)
    }
    
    func makeFirework(xMove: CGFloat, x: Int, y: Int) {
        //Create an SKNode that will act as the firework container, and place it at the position that was specified.
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        //Create a rocket sprite node, give it the name "firework" so we know that it's the important thing, adjust its colorBlendFactor property so that we can color it, then add it to the container node.
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "fireworks"
        node.addChild(firework)
        
        //Give the firework sprite node one of three random colors: cyan, green or red. I've chosen cyan because pure blue isn't particularly visible on a starry sky background picture.
        switch Int.random(in: 0...3) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
        case 3:
            firework.color = .yellow
        default:
            break
        }
        
        //Create a UIBezierPath that will represent the movement of the firework.
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMove, y: 1000))
        
        //Tell the container node to follow that path, turning itself as needed.
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        //Create particles behind the rocket to make it look like the fireworks are lit.
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        //Add the firework to our fireworks array and also to the scene.
        addChild(node)
        fireworks.append(node)
    }
    
    @objc func makeFireworks() {
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // fire five, straight up
            makeFirework(xMove: 0, x: 512, y: bottomRange)
            makeFirework(xMove: 0, x: 512-200, y: bottomRange)
            makeFirework(xMove: 0, x: 512-100, y: bottomRange)
            makeFirework(xMove: 0, x: 512+100, y: bottomRange)
            makeFirework(xMove: 0, x: 512+200, y: bottomRange)
        case 1:
            // fire five, in a fan
            makeFirework(xMove: 0, x: 512, y: bottomRange)
            makeFirework(xMove: -200, x: 512-200, y: bottomRange)
            makeFirework(xMove: -100, x: 512-100, y: bottomRange)
            makeFirework(xMove: 200, x: 512+200, y: bottomRange)
            makeFirework(xMove: 100, x: 512+100, y: bottomRange)
        case 2:
            // fire five, from the left to the right
            makeFirework(xMove: movementAmount, x: leftRange, y: bottomRange+400)
            makeFirework(xMove: movementAmount, x: leftRange, y: bottomRange+300)
            makeFirework(xMove: movementAmount, x: leftRange, y: bottomRange+200)
            makeFirework(xMove: movementAmount, x: leftRange, y: bottomRange+100)
            makeFirework(xMove: movementAmount, x: leftRange, y: bottomRange)
        case 3:
            // fire five, from the right to the left
            makeFirework(xMove: -movementAmount, x: rightRange, y: bottomRange+400)
            makeFirework(xMove: -movementAmount, x: rightRange, y: bottomRange+300)
            makeFirework(xMove: -movementAmount, x: rightRange, y: bottomRange+200)
            makeFirework(xMove: -movementAmount, x: rightRange, y: bottomRange+100)
            makeFirework(xMove: -movementAmount, x: rightRange, y: bottomRange)
        default:
            break
        }
        
        numberOfLevelsWas += 1;
        if numberOfLevelsWas >= numberOfLevels {
            gameTimer?.invalidate()
//            print(fireworks)
//            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 10) {
//                [weak self] in
//                print(self?.fireworks)
//            }
        }
    }
    
    func checkTouch(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "fireworks" else {
                continue
            }
            
            for parent in fireworks {
                guard let fireword = parent.children.first as? SKSpriteNode else {
                    continue
                }
                
                if fireword.name == "selected" && fireword.color != node.color {
                    fireword.name = "fireworks"
                    fireword.colorBlendFactor = 1
                }
            }
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouch(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouch(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExplodes = 0

        for (index, fireworkContent) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContent.children.first as? SKSpriteNode else {
                continue
            }
            
            if firework.name == "selected" {
                explode(firework: fireworkContent)
                fireworks.remove(at: index)
                numExplodes += 1
            }
        }
        
        switch numExplodes {
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1200
        case 4:
            score += 2500
        case 5:
            score += 5000
        default:
            break
        }
    }
}
