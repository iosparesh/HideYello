import SceneKit

final class CameraNode: SCNNode {
    static var offset: Float = 5
    var yoffset: Float = 5
    

    override init() {
        super.init()

        camera = SCNCamera()
        camera?.orthographicScale = 9
        camera?.zNear = 0
        camera?.zFar = 100
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
