import SceneKit

final class CameraNode: SCNNode {
    static var offset: Float = 10
    var yoffset: Float = 10
    

    override init() {
        super.init()

        camera = SCNCamera()
        position = SCNVector3(x: 0, y: yoffset, z: CameraNode.offset)
        eulerAngles = SCNVector3(
            x: -getRadianFor(degree: 22),
            y: 0,
            z: 0
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func getRadianFor(degree: Float) -> Float {
        return Float(Double.pi/180) * degree
    }
}
