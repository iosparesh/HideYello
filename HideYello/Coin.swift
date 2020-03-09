//
//  Coin.swift
//  HideYello
//
//  Created by Paresh Prajapati on 26/02/20.
//  Copyright © 2020 SolutionAnalysts. All rights reserved.
//

import SceneKit
import Foundation

class Coin: SCNNode {
    override init() {
           super.init()
           // create player
        
           let playerGeometry = SCNSphere(radius: 1)
           playerGeometry.firstMaterial?.diffuse.contents = UIImage(named: "coin")
            name = "coin"
           // give the looks
           geometry = playerGeometry

           // define shape, here a box around the player
           let shape = SCNPhysicsShape(
               geometry: playerGeometry,
               // default is box, give it a physics shape near to its looking shape
            options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox]
           )

           // assign physics body based on geometry body (here: player)
            physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
            physicsBody?.angularVelocityFactor = SCNVector3Zero
            physicsBody?.contactTestBitMask = 3
            physicsBody?.categoryBitMask = 1
            physicsBody?.collisionBitMask = 2
        physicsBody?.mass = 0.5
            physicsBody?.isAffectedByGravity =  false
       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       var directionAngle: SCNFloat = 0.0 {
           didSet {
               if directionAngle != oldValue {
                   // action that rotates the node to an absolute angle in radian.
                   let action = SCNAction.rotateTo(
                       x: 0.0,
                       y: CGFloat(directionAngle),
                       z: 0.0,
                       duration: 0.1, usesShortestUnitArc: true
                   )
                   runAction(action)
               }
           }
       }

       let speed: Float = 0.3

       func walkInDirection(_ direction: float3) {
           let currentPosition = float3(position)
           position = SCNVector3(currentPosition + direction)

       }
}
