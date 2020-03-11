//
//  Bomb.swift
//  HideYello
//
//  Created by Paresh Prajapati on 26/02/20.
//  Copyright © 2020 SolutionAnalysts. All rights reserved.
//

import Foundation
import  SceneKit

class Bomb: SCNNode {
    override init() {
        super.init()
        // create player
     
        let playerGeometry = SCNSphere(radius: 0.5)
        playerGeometry.firstMaterial?.diffuse.contents = UIImage(named: "bomb")
        name = "bomb"
        // give the looks
        geometry = playerGeometry

        let shape = SCNPhysicsShape(
            geometry: playerGeometry,
         options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox]
        )

         physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
//         physicsBody?.angularVelocityFactor = SCNVector3Zero
         physicsBody?.contactTestBitMask = 3
         physicsBody?.categoryBitMask = 2
         physicsBody?.collisionBitMask = 1
        physicsBody?.mass = 0
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
        var currentPosition = float3(position)
        position = SCNVector3(currentPosition + direction)
    }
    
}
