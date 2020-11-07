//
//  GameScene.swift
//  Project14
//
//  Created by Macbook Pro on 11/5/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var slots = [WhackSlot]()
    var popupTime = 0.85
    
    var numRound = 0
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i*170), y: 410)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i*170), y: 320)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i*170), y: 230)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i*170), y: 140)) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createPinguin()
        }
    }
    
    func createPinguin() {
        numRound += 1
        if numRound >= 30 {
            for slot in slots {
                slot.hide()
            }
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.zPosition = 1
            gameOver.position = CGPoint(x: 513, y: 384)
            run(SKAction.playSoundFileNamed("gameOver.m4a", waitForCompletion: false))
            addChild(gameOver)
            let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.text = "Score \(score)"
            scoreLabel.position = CGPoint(x: 513, y: 200)
            scoreLabel.fontSize = 40
            scoreLabel.zPosition = 1
            addChild(scoreLabel)
            return
        }
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show()
        
        if Int.random(in: 0...12) > 4 { slots[1].show() }
        if Int.random(in: 0...12) > 8 { slots[2].show() }
        if Int.random(in: 0...12) > 10 { slots[3].show() }
        if Int.random(in: 0...12) > 11 { slots[4].show() }
        
        let minDelay = popupTime / 2
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.createPinguin()
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNotes = nodes(at: location)
        
        for node in tappedNotes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            whackSlot.charNode.xScale = 0.85
            whackSlot.charNode.yScale = 0.85
            
            if node.name == "penguinGood" {
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "penguinEvil" {
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            }
        }
    }
}
