//
//  GameScene.swift
//  Project23
//
//  Created by Macbook Pro on 11/17/20.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var popupTime = 0.9 // time between the last enemy being destroyed and a new one being created
    var sequences = [SenqueceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequence = true
    
    var isSliceSoundActive = false
    var bombSoundEffect: AVAudioPlayer?
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var activeSlicePoints = [CGPoint]()
    
    var lives = 3
    var livesImage = [SKSpriteNode]()
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    enum SenqueceType: CaseIterable {
        case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain, fastBonus
    }
    
    enum ForceBomb {
        case always, never, random
    }
    var activeEnemy = [SKSpriteNode]()
    
    var isGameEnd = false
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "sliceBackground")
        bg.position = CGPoint(x: 512, y: 368)
        bg.zPosition = -1
        bg.blendMode = .replace
        addChild(bg)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        score = 0
        addChild(scoreLabel)
        
        physicsWorld.speed = 0.85
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        
        createLives()
        createSlices()
        
        sequences = [.oneNoBomb, .one, .twoWithOneBomb, .two, .three, .four, .chain, .fastBonus]
        
        for _ in 0...1000 {
            if let nextSequence = SenqueceType.allCases.randomElement() {
                sequences.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in self?.tossEnemy() }
    }
    
    func createLives() {
        for i in 0..<3 {
            let live = SKSpriteNode(imageNamed: "sliceLife")
            live.position = CGPoint(x: 700 + i*70, y: 700)
            addChild(live)
            livesImage.append(live)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = SKColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = .white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        activeSliceFG.alpha = 1
        activeSliceBG.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameEnd {
            return
        }
        
        guard let touch = touches.first else {
            return
        }
        activeSlicePoints.append(touch.location(in: self))
        redrawActiveSlice()
        
        if !isSliceSoundActive {
            playSliceSound()
        }
        
        let nodesAtPoint = nodes(at: touch.location(in: self))
        for case let node as SKSpriteNode in nodesAtPoint {
            if node.name == "enemy" || node.name == "bonus" {
                if let emitte = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitte.position = node.position
                    addChild(emitte)
                }
                if node.name == "bonus" {
                    score += 5
                } else {
                    score += 1
                }
                
                node.name = ""
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(by: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                
                let seq = SKAction.sequence([scaleOut, fadeOut, .removeFromParent()])
                node.run(seq)
                
                if let index = activeEnemy.firstIndex(of: node) {
                    activeEnemy.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "bomb" {
                guard let bombC = node.parent as? SKSpriteNode else {
                    continue
                }
                
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = bombC.position
                    addChild(emitter)
                }
                
                node.name = ""
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(by: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                
                let seq = SKAction.sequence([scaleOut, fadeOut, .removeFromParent()])
                bombC.run(seq)
                
                if let index = activeEnemy.firstIndex(of: bombC) {
                    activeEnemy.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("explosion.cah", waitForCompletion: false))
                endGame(triggerByBomb: true)
            }
        }
    }
    
    func playSliceSound() {
        isSliceSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let nameSound = "swoosh\(randomNumber).caf"
        
        let sound = SKAction.playSoundFileNamed(nameSound, waitForCompletion: true)
        
        run(sound) { [weak self] in
            self?.isSliceSoundActive = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    func createEnemy(forceBomb: ForceBomb = .random, bonus: Bool = false) {
        let enemy: SKSpriteNode
        
        let enemyType: Int
        if forceBomb == .always {
            enemyType = 0
        } else if forceBomb == .never {
            enemyType = 1
        } else if bonus {
            enemyType = 6
        } else {
            enemyType = Int.random(in: 0...5)
        }
        
        if enemyType == 0 {
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContent"
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            if let path = Bundle.main.url(forResource: "SliceBombFuse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 74)
                enemy.addChild(emitter)
            }
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            if enemyType == 6 {
                enemy.name = "bonus"
            } else {
                enemy.name = "enemy"
            }
        }
        
        let randomBottom = CGPoint(x: Int.random(in: 64...960), y: -124)
        enemy.position = randomBottom
        
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        
        if randomBottom.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomBottom.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomBottom.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }
        
        let randomYVelocity = Int.random(in: 24...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.collisionBitMask = 0
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        
        
        addChild(enemy)
        activeEnemy.append(enemy)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var bombCount = 0
        
        for enemy in activeEnemy {
            if enemy.name == "bombContent" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
        
        if activeEnemy.count > 0 {
            for (index, enemy) in activeEnemy.enumerated().reversed() {
                if enemy.position.y < -140 {
                    if enemy.name == "enemy" {
                        substractLife()
                    }
                    enemy.name = ""
                    enemy.removeFromParent()
                    activeEnemy.remove(at: index)
                }
            }
        } else {
            if !nextSequence {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in self?.tossEnemy() }
                
                nextSequence = true
            }
        }
    }
    
    func tossEnemy() {
        if isGameEnd {
            return
        }
        
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequences[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
        case .one:
            createEnemy()
        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
        case .two:
            createEnemy()
            createEnemy()
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
        case .chain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }
        case .fastChain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
        case .fastBonus:
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy(bonus: true)}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy(bonus: true)}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy(bonus: true)}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy(bonus: true)}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy(bonus: true)}
        }
        
        sequencePosition += 1
        nextSequence = false
    }
    
    func substractLife() {
        lives -= 1
        
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var live: SKSpriteNode
        
        if lives == 2 {
            live = livesImage[0]
        } else if lives == 1 {
            live = livesImage[1]
        } else {
            live = livesImage[0]
            endGame(triggerByBomb: false)
        }
        
        live.texture = SKTexture(imageNamed: "sliceLifeGone")
        
        live.xScale = 1.3
        live.yScale = 1.3
        run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    func endGame(triggerByBomb: Bool) {
        if isGameEnd {
            return
        }

        let gameOverSprite = SKLabelNode(fontNamed: "Chalkduster")
        gameOverSprite.position = CGPoint(x: 512, y: 384)
        gameOverSprite.fontSize = 98
        gameOverSprite.text = "GAME OVER"
        addChild(gameOverSprite)
        
        isGameEnd = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        if triggerByBomb {
            livesImage[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImage[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImage[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
    }
}
