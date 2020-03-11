//
//  GameViewController.swift
//  HideYello
//
//  Created by Paresh Prajapati on 25/02/20.
//  Copyright © 2020 SolutionAnalysts. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {

    var gameView: GameView {
        return view as! GameView
    }
    
    var speedButtonUp:UIButton!
    var speedButtonDown:UIButton!
    var stars = [[Coin]]()
    var bombs = [Bomb]()
    var bullets = [BulletNode]()
    var timer: Timer?
    var ship = ShipNode()
    var cameraNode = CameraNode()
    var lightNode = LightNode()
    var floorNode: FloorNode!
    var touch: UITouch?
    var direction = float2(0, 0)
    var lastUpdatedX:Float = 0
    var emetter: SCNNode!
    var gear:Float = 1
    var fireDistance:Float {
        return -200.0 * gear
    }
    var startPoint: SCNVector3!
    var shipMesh: SCNNode!
    var target: TargetNode!
    var lastWidthRatio:Float = 0
    var previousTranslation:CGPoint = .zero
//    var bulletNode:BulletNode!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        gameView.scene = scene

        gameView.delegate = self
        gameView.scene?.physicsWorld.contactDelegate = self
        gameView.isPlaying = true
        
        let light = SCNLight()
        light.type = .directional
        light.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        light.color = UIColor.white
        light.castsShadow = true
        light.automaticallyAdjustsShadowProjection = true
        light.shadowMode = .deferred
        let sunLightNode = SCNNode()
        sunLightNode.position = SCNVector3(x: 1_000, y: 1_000, z: 0)
        sunLightNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: .pi * 1.5)
        sunLightNode.light = light
        scene.rootNode.addChildNode(sunLightNode)

        let omniLightNode: SCNNode = {
            let omniLightNode = SCNNode()
            let light: SCNLight = {
                let light = SCNLight()
                light.type = .omni
                return light
            }()
            omniLightNode.light = light
            return omniLightNode
        }()
        scene.rootNode.addChildNode(omniLightNode)
        floorNode = FloorNode()
        scene.rootNode.addChildNode(floorNode)
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(lightNode)
        ship.position = SCNVector3(0,4.0,0)
        scene.rootNode.addChildNode(ship)
        let button = UIButton(frame: CGRect(x: self.view.frame.maxX - 85, y: self.view.frame.maxY - 105, width: 68, height: 68))
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = button.frame.size.height / 2
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(touchDownRepeat), for: .touchUpInside)
        self.view.addSubview(button)
        self.view.bringSubviewToFront(button)
        
        speedButtonUp = UIButton(frame: CGRect(x: self.view.frame.maxX - 85, y: self.view.frame.maxY - 205, width: 50, height: 30))
        speedButtonUp.contentMode = .scaleAspectFit
        speedButtonUp.setTitle("Up", for: .normal)
        speedButtonUp.backgroundColor = UIColor.red
        speedButtonUp.addTarget(self, action: #selector(touchDownSpeed), for: .touchUpInside)
        self.view.addSubview(speedButtonUp)
        self.view.bringSubviewToFront(speedButtonUp)
        
        speedButtonDown = UIButton(frame: CGRect(x: self.view.frame.maxX - 85, y: self.view.frame.maxY - 170, width: 50, height: 30))
        speedButtonDown.contentMode = .scaleAspectFit
        speedButtonDown.setTitle("Down", for: .normal)
        speedButtonDown.backgroundColor = UIColor.red
        speedButtonDown.addTarget(self, action: #selector(touchDownSpeed), for: .touchUpInside)
        self.view.addSubview(speedButtonDown)
        self.view.bringSubviewToFront(speedButtonDown)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true, block: createStars)
        target = TargetNode()
        target.position = SCNVector3(ship.position.x, ship.position.y, ship.position.z + fireDistance)
        lastUpdatedX = target.position.x
        scene.rootNode.addChildNode(target)
        let sceneplane = SCNScene(named: "art.scnassets/ship.scn")!
        emetter = sceneplane.rootNode.childNode(withName: "shipMesh", recursively: true)
        startPoint = ship.position
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
//        gameView.addGestureRecognizer()
    }
       @objc func pan(gesture: UIPanGestureRecognizer) {
           gesture.minimumNumberOfTouches = 1
           gesture.maximumNumberOfTouches = 1
           if gesture.numberOfTouches == 1 {
               let view = self.view as! SCNView
               let node = view.scene!.rootNode.childNode(withName: "CameraHandler", recursively: false)
               let translation = gesture.translation(in: view)

               var dx = previousTranslation.x - translation.x
               var dy = previousTranslation.y - translation.y

               dx = dx / 100
               dy = dy / 100
               print(dx,dy)

               let cammat = node!.transform
               let transmat = SCNMatrix4MakeTranslation(Float(dx), 0, Float(dy))

               switch gesture.state {
               case .began:
                   previousTranslation = translation
                   break;
               case .changed:
                   node!.transform = SCNMatrix4Mult(transmat, cammat)
                   break
               default: break
               }
           }
       }
       @objc func rotate(gesture: UIPanGestureRecognizer) {
           gesture.minimumNumberOfTouches = 2
           gesture.maximumNumberOfTouches = 2
           if gesture.numberOfTouches == 2 {
               let view = self.view as! SCNView
               let node = view.scene!.rootNode.childNode(withName: "CameraHandler", recursively: false)
               let translate = gesture.translation(in: view)

               var widthRatio:Float = 0
               widthRatio = Float(translate.x / 10) * Float(Double.pi / 180)

               switch gesture.state {
               case .began:
                   lastWidthRatio = node!.eulerAngles.y
                   break
               case .changed:
                   node!.eulerAngles.y = lastWidthRatio + widthRatio
                   break
               default: break
               }
           }
       }
    @objc
    func createStars(_ timer: Timer) {
        if stars.count > 3 {
            stars.first?.forEach({ (coin) in
                coin.removeFromParentNode()
            })
            stars.removeFirst()
        }
        if bombs.count > 10 {
            bombs.first?.removeFromParentNode()
            bombs.removeFirst()
        }
        let shipx = ship.eulerAngles.x - 25
        let new = ship.eulerAngles.x + 25
        let aRandomX = Float.random(in: shipx ... new)
        let randomVector = SCNVector3(Double(aRandomX), Double(ship.position.y), Double(ship.position.z + (-50)))
        var arrCoins = [Coin]()
        for i in 0..<5 {
            let distance = distanceBetweenVectors(v1: ship.position, v2: randomVector)
            guard distance > 10 else { return }
            if i == 0 {
                let bomb = Bomb()
                bomb.position = SCNVector3(randomVector.x + 5, randomVector.y, randomVector.z + Float(i * 2))
                gameView.scene?.rootNode.addChildNode(bomb)
                bombs.append(bomb)
            } else {
                let coin = Coin()
                coin.position = SCNVector3(randomVector.x, randomVector.y, randomVector.z + Float(i * 2))
                
                
                arrCoins.append(coin)
                gameView.scene?.rootNode.addChildNode(coin)
            }
        }
        stars.append(arrCoins)
//        floorNode.updateGeometry()
    }
    @objc
    func touchDownRepeat(_ sender: UIButton) {
        createBulletandFire()
    }
    @objc
    func touchDownSpeed(_ sender: UIButton) {
        guard let speed = sender.titleLabel?.text else { return }
        
        if speed == "Up" {
            
            guard gear != 4 else { return }
            gear = gear + 1
            ship.speed = 0.3 * gear
            target.speed = 0.3 * gear
        } else {
            guard gear != 0 else { return }
            gear = gear - 1
            ship.speed = 0.3 * gear
            target.speed = 0.3 * gear
        }
         print("\(gear)")
    }
    func createBulletandFire() {
        
        let bulletNode = BulletNode()
        bulletNode.name = "bullet"
        bulletNode.position = SCNVector3(ship.position.x, ship.position.y, ship.position.z + -5)
        bulletNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        bulletNode.physicsBody?.isAffectedByGravity = false
        bulletNode.physicsBody?.contactTestBitMask = 3
        bulletNode.physicsBody?.categoryBitMask = 2
        bulletNode.physicsBody?.collisionBitMask = 1
        bulletNode.physicsBody?.mass = 0.5
        gameView.scene?.rootNode.addChildNode(bulletNode)
        if bullets.count > 2 {
            bullets.first?.removeFromParentNode()
            bullets.removeFirst()
        }
        bullets.append(bulletNode)
        bulletNode.physicsBody?.applyForce(SCNVector3(ship.presentation.position.x, ship.presentation.position.y, ship.presentation.position.z + 25), asImpulse: true)
    }
    func createExplosion(geometry: SCNGeometry?, position: SCNVector3?,
      rotation: SCNVector4?) {
        guard let position = position else { return }
        guard let rotation = rotation else { return }
        let explosion =
        SCNParticleSystem(named: "art.scnassets/Explode.scnp", inDirectory:
      nil)!
        explosion.emitterShape = geometry
        let rotationMatrix =
        SCNMatrix4MakeRotation(rotation.w, rotation.x,
          rotation.y, rotation.z)
      let translationMatrix =
        SCNMatrix4MakeTranslation(position.x, position.y,
          position.z)
      let transformMatrix =
        SCNMatrix4Mult(rotationMatrix, translationMatrix)
        gameView.scene?.addParticleSystem(explosion, transform:
        transformMatrix)
    }
    
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
extension GameViewController {

    // store touch in global scope
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touch {

            // check whether our touch is within our dpad
            let touchLocation = touch.location(in: self.view)
            
            if gameView.virtualDPad().contains(touchLocation) {

                let middleOfCircleX = gameView.virtualDPad().origin.x + 75
                let middleOfCircleY = gameView.virtualDPad().origin.y + 75

                let lengthOfX = Float(touchLocation.x - middleOfCircleX)
                let lengthOfY = Float(touchLocation.y - middleOfCircleY)
                direction = float2(x: lengthOfX, y: lengthOfY)
                direction = normalize(direction)

                let degree = atan2(direction.x, direction.y)
                ship.directionAngle = degree
                target.directionAngle = degree
                let oppositex = (fireDistance - 1) * tan(degree)
                target.position.x = (oppositex * ship.speed + ship.position.x + direction.x)
                lastUpdatedX = oppositex
            }
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let directionInV3 = vector_float3(x: direction.x, y: 0, z: direction.y)
        ship.walkInDirection(directionInV3)
        
        let shipPresentationNode = ship.presentation
        let shipPresentationPos = shipPresentationNode.position
        let targetPosition = SCNVector3(shipPresentationPos.x, shipPresentationPos.y + 10, shipPresentationPos.z + 10)
        var cameraposition = cameraNode.position
        let camDamping:Float = 0.3
        
        let xComponent = cameraposition.x * (1 - camDamping) + targetPosition.x * camDamping
        let yComponent = cameraposition.y * (1 - camDamping) + targetPosition.y * camDamping
        let zComponent = cameraposition.z * (1 - camDamping) + targetPosition.z * camDamping
        cameraposition = SCNVector3(xComponent, yComponent, zComponent)
        cameraNode.position = cameraposition
        
        let vector = target.walkInDirection(directionInV3)
        let oppositex = (fireDistance - 1) * tan(ship.directionAngle)
        target.position.x = (oppositex * ship.speed + ship.presentation.position.x + direction.x)
        target.position.y = vector.y
        target.position.z = vector.z
        // cameraNode.position.x = ship.presentation.position.x
        // cameraNode.position.z = ship.presentation.position.z + CameraNode.offset
        let distance = ship.position - startPoint
        let length = distance.length / 100
        ScoreBoard.shared.totalKm = length
        ScoreBoard.shared.delegate.updateKilometer(text: String(format: "%.2f", length))
    }
}
extension GameViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeA.physicsBody?.collisionBitMask == 1 && contact.nodeB.physicsBody?.collisionBitMask == 2 || contact.nodeA.physicsBody?.collisionBitMask == 2 && contact.nodeB.physicsBody?.collisionBitMask == 1 {
            let nameA = contact.nodeA.name ?? ""
            let nameB = contact.nodeB.name ?? ""
            if nameA == "bomb" || nameB == "bomb" {
                DispatchQueue.main.async {
                    let node:SCNNode = (nameA == "bomb") ? contact.nodeA : contact.nodeB
                    self.createExplosion(geometry: node.geometry, position: node.presentation.position,
                                         rotation: node.presentation.rotation)
                    node.removeFromParentNode()
                    if nameB != "bullet" && nameA != "bullet" && nameB != "coin" && nameA != "coin" {
                        if self.gameView.bombremains > 0 {
                            ScoreBoard.shared.delegate.didUpdateBomb()
                        } else {
                            self.ship.speed = 0
                            self.target.speed = 0
                            self.gear = 0
                            self.GameOver()
                        }
                    }
                }
            } else if nameA == "coin" || nameB == "coin" {
                ScoreBoard.shared.updateStars(count: 1)
                let node:SCNNode = (nameA == "coin") ? contact.nodeA : contact.nodeB
                node.removeFromParentNode()
            }
        }
    }
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        
    }
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
    }
    func GameOver() {
        DispatchQueue.main.async {
            let gameOver = self.storyboard?.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
            gameOver.modalPresentationStyle = .overCurrentContext
            gameOver.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.present(gameOver, animated: true, completion: nil)
            self.stars.forEach { (coind) in
                coind.forEach { (coin) in
                    coin.removeFromParentNode()
                }
            }
            self.stars.removeAll()
            self.bombs.forEach { (bomb) in
                bomb.removeFromParentNode()
            }
            self.bombs.removeAll()
            self.bullets.forEach { (bullet) in
                bullet.removeFromParentNode()
            }
            self.bullets.removeAll()
            self.ship.position = self.startPoint
        }
    }
}

