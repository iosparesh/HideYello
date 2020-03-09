import SceneKit
import SpriteKit

/// Is used in Main.storyboard
/// under Identity Inspector
final class GameView: SCNView {
    
    // typically used for additional set up
    var fireSate:SKShapeNode!
    var labelStar: SKLabelNode!
    var kmLabel: SKLabelNode!
    var bombs = [SKSpriteNode]()
    var skScene: SKScene!
    var bombremains = 5
    override func awakeFromNib() {
        super.awakeFromNib()

        setup2DOverlay()
    }

    func setup2DOverlay() {
        let viewHeight = bounds.size.height
        let viewWidth = bounds.size.width

        // initiate a sprite kit scene (the actual overlay)
        let sceneSize = CGSize(width: viewWidth, height: viewHeight)
        skScene = SKScene(size: sceneSize)
        // Modify the SKScene's actual size to exactly match the SKView.
        skScene.scaleMode = .resizeFill

        let dpadShape = SKShapeNode(circleOfRadius: 75)
        dpadShape.strokeColor = .white
        dpadShape.lineWidth = 2.0

        // the position is initially at (0, 375) of the views coordinate system
        // the `position` of the dpadShape is at the middle of the shape
        // this is why we put it by the half of its width to the right
        // with a little offset/margin of 10. Same for the height.
        dpadShape.position.x = dpadShape.frame.size.width / 2 + 10
        dpadShape.position.y = dpadShape.frame.size.height / 2 + 10

        // add the dpad shape to the sprite kit scene
        skScene.addChild(dpadShape)

        // disables skScene to receive touch
        // so it goes through this layer
        // which means to our GameView scene
        skScene.isUserInteractionEnabled = false

        // assign the sprite kit scene to the scene kit view.
        
        
        labelStar = SKLabelNode(text: "0000")
        labelStar.text = " ★ 0000"
        labelStar.fontColor = UIColor.white
        labelStar.fontSize = 30
        labelStar.numberOfLines = 0
        labelStar.horizontalAlignmentMode = .right
        labelStar.fontColor = UIColor.black
        labelStar.fontName = "Hiragino Mincho ProN W6"
        labelStar.color = UIColor.black
        labelStar.position.x = UIScreen.main.bounds.size.width - 75
        labelStar.position.y = UIScreen.main.bounds.size.height - 75
        skScene.addChild(labelStar)
        
        
        kmLabel = SKLabelNode(text: "0000")
        kmLabel.text = " KM : 0000"
        kmLabel.fontColor = UIColor.white
        kmLabel.fontSize = 30
        kmLabel.numberOfLines = 0
        kmLabel.horizontalAlignmentMode = .right
        kmLabel.fontColor = UIColor.black
        kmLabel.fontName = "Hiragino Mincho ProN W6"
        kmLabel.color = UIColor.black
        kmLabel.position.x = UIScreen.main.bounds.size.width - 75
        kmLabel.position.y = (UIScreen.main.bounds.size.height - 75) - labelStar.frame.size.height
        skScene.addChild(kmLabel)
        
        ScoreBoard.shared.delegate = self
        
//        addSpriteBomb(skScene: skScene)
        var X:CGFloat = 35.0
        for _ in 1..<6 {
            let bombtext = SKTexture(image: UIImage(named: "bomb")!)
            let sprite = SKSpriteNode(texture: bombtext)
//            sprite.size = CGSize(width: 30, height: 30)
            sprite.position.x = X
            sprite.position.y = UIScreen.main.bounds.size.height - 50
            skScene.addChild(sprite)
            X = X + sprite.frame.size.width + 2
            bombs.append(sprite)
        }
        overlaySKScene = skScene
    }

    func virtualDPad() -> CGRect {
        var vDPad = CGRect(x: 0, y: 0, width: 150, height: 150)
        vDPad.origin.y = bounds.size.height - vDPad.size.height - 10
        vDPad.origin.x = 10
        return vDPad
    }
}
extension GameView: UpdateScrollDelegate {
    func didUpdatePoint(text: String) {
        labelStar.text = " ★ \(text)"
    }
    func didUpdateBomb() {
        if bombremains > 0 {
            self.bombs[bombremains - 1].isHidden = true
            self.bombremains -= 1
        }
    }
    func restartGame() {
        self.bombs.forEach { (node) in
            node.isHidden = false
        }
        self.kmLabel.text = "KM : 0000"
        self.bombremains = 5
    }
    func updateKilometer(text: String) {
        self.kmLabel.text = "KM : \(text)"
    }
}
