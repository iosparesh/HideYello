//
//  TargetNode.swift
//  HideYello
//
//  Created by Paresh Prajapati on 28/02/20.
//  Copyright © 2020 SolutionAnalysts. All rights reserved.
//

import Foundation
import SceneKit

class TargetNode: SCNNode {
    override init() {
        super.init()
        let playerGeometry = SCNSphere(radius: 1)
        playerGeometry.firstMaterial?.diffuse.contents = UIColor.green
        name = "target"
        // give the looks
        geometry = playerGeometry
    }
    
    required init?(coder: NSCoder) {
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

    func walkInDirection(_ direction: float3) -> SCNVector3 {
           let currentPosition = float3(position)
           return SCNVector3(currentPosition + (direction * speed))
        
       }
}
