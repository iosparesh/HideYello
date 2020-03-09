//
//  Ship.swift
//  HideYello
//
//  Created by Paresh Prajapati on 25/02/20.
//  Copyright © 2020 SolutionAnalysts. All rights reserved.
//

import SceneKit

class ShipNode : SCNNode {
    var changedX:Float = 0
    override init() {
        super.init()
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let ship = scene.rootNode.childNode(withName: "shipMesh", recursively: true)!
        self.addChildNode(ship)
        changedX = ship.position.x
        physicsBody?.angularVelocityFactor = SCNVector3Zero
//        physicsBody?.contactTestBitMask = 3
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        physicsBody?.categoryBitMask = 2
        physicsBody?.collisionBitMask = 1
        physicsBody?.mass = 5
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

    var speed: Float = 0.3

    func walkInDirection(_ direction: float3) {
        let currentPosition = float3(position)
        position = SCNVector3(currentPosition + direction * speed)
//        print("Ship \(transform.m31)")
    }
    func getPointTo(_ direction: float3, positionh: float3) -> SCNVector3 {
         return SCNVector3(positionh + direction * speed)
    }
    
}
