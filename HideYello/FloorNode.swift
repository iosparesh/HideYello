import SceneKit

final class FloorNode: SCNNode {

    override init() {
        super.init()

        // infinite floor
        let floorGeometry = SCNFloor()
        floorGeometry.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/grass.jpeg")
        floorGeometry.firstMaterial?.diffuse.wrapS = .repeat
        floorGeometry.firstMaterial?.diffuse.wrapT = .repeat
//        floorGeometry.firstMaterial!.colorBufferWriteMask = []
//        floorGeometry.firstMaterial!.readsFromDepthBuffer = true
//        floorGeometry.firstMaterial!.writesToDepthBuffer = true
//        floorGeometry.firstMaterial!.lightingModel = .physicallyBased

        
        // the higher the number the more often the repetition (the smaller the image get)
        floorGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(25, 25, 25)
        
        let floorShape = SCNPhysicsShape(geometry: floorGeometry, options: nil)
        let floorBody = SCNPhysicsBody(type: .static, shape: floorShape)

        physicsBody = floorBody
        physicsBody?.categoryBitMask = 4
        physicsBody?.collisionBitMask = 1
        geometry = floorGeometry

    }
    func updateGeometry() {
        if ScoreBoard.shared.totalKm > 6 {
            geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/m1.jpeg")
            geometry?.firstMaterial?.diffuse.wrapS = .clamp
            geometry?.firstMaterial?.diffuse.wrapT = .clamp
        }
        else if ScoreBoard.shared.totalKm > 4.00 {
            geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/m2.jpeg")
            geometry?.firstMaterial?.diffuse.wrapS = .clamp
            geometry?.firstMaterial?.diffuse.wrapT = .clamp
        }
        else if ScoreBoard.shared.totalKm > 2 {
            geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/texture.png")
            geometry?.firstMaterial?.diffuse.wrapS = .clamp
            geometry?.firstMaterial?.diffuse.wrapT = .clamp
        }
    }
    	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
