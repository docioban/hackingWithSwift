//
//  WhackSlot.swift
//  Project14
//
//  Created by Macbook Pro on 11/6/20.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var sprite: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let crope = SKCropNode()
        crope.position = CGPoint(x: 0, y: 15)
        crope.zPosition = 1
        crope.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        crope.addChild(charNode)
        addChild(crope)
    }
    
    func show() {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.1))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "penguinGood"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "penguinEvil"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            [weak self] in
            self?.hide()
        }
    }
        
    func hide() {
        if !isVisible { return }
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.1))
        isVisible = false
        
        if let fileParticles = SKEmitterNode(fileNamed: "MyParticle") {
            fileParticles.position = sprite.position
            fileParticles.numParticlesToEmit = 50
            addChild(fileParticles)
        }
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run{[unowned self] in self.isVisible = false}
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
        
        if let fileParcticles = SKEmitterNode(fileNamed: "HitSmoke") {
            fileParcticles.position = charNode.position
            fileParcticles.numParticlesToEmit = 8
            addChild(fileParcticles)
        }
        
    }
}
