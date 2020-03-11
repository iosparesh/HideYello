//
//  Ship.swift
//  HideYello
//
//  Created by Paresh Prajapati on 25/02/20.
//  Copyright © 2020 SolutionAnalysts. All rights reserved.
//

import SceneKit

class ShipNode : SCNNode {
    var engineForce: CGFloat = 0
    var brakingForce: CGFloat = 0
    var steearingAngle: CGFloat = 0
    var changedX:Float = 0
    var vehicle = SCNPhysicsVehicle()
    override init() {
        super.init()
        let scene = SCNScene(named: "art.scnassets/rc_car.scn")!
        let chassis = scene.rootNode.childNode(withName: "rccarBody", recursively: true)!
        let frontLeftWheel = chassis.childNode(withName: "wheelLocator_FL", recursively: true)!
        let frontRightWheel = chassis.childNode(withName: "wheelLocator_FR", recursively: true)!
        let rearLeftWheel = chassis.childNode(withName: "wheelLocator_RL", recursively: true)!
        let rearRightWheel = chassis.childNode(withName: "wheelLocator_RR", recursively: true)!

        // physic behavior for wheels

        let v_frontLeftWheel = SCNPhysicsVehicleWheel(node: frontLeftWheel)
        let v_frontRightWheel = SCNPhysicsVehicleWheel(node: frontRightWheel)
        let v_rearRightWheel = SCNPhysicsVehicleWheel(node: rearLeftWheel)
        let v_rearLeftWheel = SCNPhysicsVehicleWheel(node: rearRightWheel)
        
        chassis.position = SCNVector3(0,0,0)
//        chassis.eulerAngles.y = directionAngle
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chassis, options: [SCNPhysicsShape.Option.collisionMargin: true]))
        body.mass = 1
        chassis.physicsBody = body
        self.vehicle = SCNPhysicsVehicle(chassisBody: chassis.physicsBody!, wheels: [v_rearRightWheel, v_rearLeftWheel, v_frontRightWheel, v_frontLeftWheel])
        self.addChildNode(chassis)
        changedX = chassis.position.x
        physicsBody?.angularVelocityFactor = SCNVector3Zero
//        physicsBody?.contactTestBitMask = 3
//        physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 6
//        physicsBody?.mass = 5
        physicsBody?.isAffectedByGravity =  true
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

    func walkInDirection(_ direction: vector_float3) {
        let currentPosition = vector_float3(position)
//        position = SCNVector3(currentPosition + direction * speed)
        rotation = SCNVector4(direction.x, direction.y, direction.z, 0)
    }
    
}
