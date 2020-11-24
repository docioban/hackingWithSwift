//
//  ViewController.swift
//  Project27
//
//  Created by Macbook Pro on 11/23/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var numbarTapped = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawRectangle()
    }

    @IBAction func tapButton(_ sender: Any) {
        numbarTapped += 1
        
        if numbarTapped > 7 {
            numbarTapped = 0
        }
        
        switch numbarTapped {
        case 0:
            drawRectangle()
            
        case 1:
            drawEllipses()
            
        case 2:
            drawcheckerboards()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
            
        case 5:
            drawImageAndText()
            
        case 6:
            drawEmoji()
            
        case 7:
            drawTwin()
            
        default:
            break
        }
    }
    
    func drawTwin() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image {
            ctx in
            
            let heightLetter = 250
            let heightPoint = 50
            let sizeLetter = 10
            
            // T
            ctx.cgContext.move(to: CGPoint(x: 0, y: heightPoint))
            ctx.cgContext.addLine(to: CGPoint(x: 150, y: heightPoint))
            ctx.cgContext.move(to: CGPoint(x: 75, y: heightPoint))
            ctx.cgContext.addLine(to: CGPoint(x: 75, y: heightLetter + heightPoint))
            
            // W
            ctx.cgContext.move(to: CGPoint(x: 185, y: heightPoint))
            ctx.cgContext.addLine(to: CGPoint(x: 210, y: heightLetter + heightPoint - 20))
            ctx.cgContext.addLine(to: CGPoint(x: 255, y: heightPoint + 80))
            ctx.cgContext.addLine(to: CGPoint(x: 290, y: heightLetter + heightPoint - 20))
            ctx.cgContext.addLine(to: CGPoint(x: 325, y: heightPoint))
            
            // I
            ctx.cgContext.move(to: CGPoint(x: 365, y: heightPoint))
            ctx.cgContext.addLine(to: CGPoint(x: 425, y: heightPoint))
            ctx.cgContext.move(to: CGPoint(x: 395, y: heightPoint))
            ctx.cgContext.addLine(to: CGPoint(x: 395, y: heightLetter + heightPoint))
            ctx.cgContext.move(to: CGPoint(x: 365, y: heightLetter + heightPoint - sizeLetter/2))
            ctx.cgContext.addLine(to: CGPoint(x: 425, y: heightLetter + heightPoint - sizeLetter/2))
            
            // N
            ctx.cgContext.move(to: CGPoint(x: 445, y: heightPoint))
            ctx.cgContext.addLine(to: CGPoint(x: 445, y: heightLetter + heightPoint - 20))
            ctx.cgContext.addLine(to: CGPoint(x: 507, y: heightPoint + 20))
            ctx.cgContext.addLine(to: CGPoint(x: 507, y: heightPoint + heightLetter - 20))
            
            ctx.cgContext.setLineWidth(CGFloat(sizeLetter))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image {
            ctx in
            
            let paragraphStule = NSMutableParagraphStyle()
            paragraphStule.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStule
            ]
            
           let string = "😁 😎 🥰 ⭐️"
            let atributeString = NSAttributedString(string: string, attributes: attrs)
            
            atributeString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
        }
        
        imageView.image = img
    }
    
    func drawImageAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image {
            ctx in
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let atributeString = NSAttributedString(string: string, attributes: attrs)
            
            atributeString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image{
            ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var length: CGFloat = 256

            ctx.cgContext.move(to: CGPoint(x: length, y: 50))
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi/2)
                ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image {
            ctx in
            
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
                ctx.cgContext.rotate(by: CGFloat(amount))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawcheckerboards() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image {
            ctx in
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row+col)%2 == 0 {
                        ctx.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = img
    }
    
    func drawEllipses() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image {
            ctx in
            
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.green.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.red.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image {
            ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.blue.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
}

