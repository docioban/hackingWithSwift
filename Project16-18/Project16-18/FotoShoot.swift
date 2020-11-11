//
//  FotoShoot.swift
//  Project16-18
//
//  Created by Macbook Pro on 11/9/20.
//

import UIKit
import SpriteKit

class FotoShoot: SKNode {
    var image: SKSpriteNode!
    var location: CGPoint!
    var points = 0
    var tempo = 0.0
    var isVisible = true
    var xMove: CGFloat = 100.0
    var timer: Timer!
    var namesEnemy = ["coronavirus", "facebook", "instagram", "whatsapp"]
    var nameEnemy = ""
    
    func configure(at position: CGPoint, size: CGSize, points: Int, speed: Double) {
        self.position = position
        nameEnemy = namesEnemy.randomElement()!
        image = SKSpriteNode(imageNamed: nameEnemy)
        image.position = CGPoint(x: 0, y: 0)
        image.size.height = size.height
        image.size.width = size.width
        addChild(image)
        self.points = points
        self.tempo = speed
    }
    
    func show() {
        if !isVisible { return }
        timer = Timer.scheduledTimer(timeInterval: tempo, target: self, selector: #selector(moveImage), userInfo: nil, repeats: true)
        image.texture = SKTexture(imageNamed: nameEnemy)
    }
    
    @objc func moveImage() {
        image.run(SKAction.moveBy(x: xMove, y: 0, duration: tempo))
        xMove *= -1
    }
    
    func hit() {
        timer.invalidate()
        let delay = SKAction.wait(forDuration: 0.3)
        let action = SKAction.scale(by: 0, duration: 0.5)
        image.run(SKAction.sequence([delay, action]))
    }
}
