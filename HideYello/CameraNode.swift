import SceneKit

final class CameraNode: SCNNode {
    static var offset: Float = 5
    var yoffset: Float = 2
    

    override init() {
        super.init()

        camera = SCNCamera()
//        camera?.orthographicScale = 9
//        camera?.zNear = 10
//        camera?.zFar = 25
        position = SCNVector3(x: 0, y: yoffset, z: CameraNode.offset)
        rotation  = SCNVector4Make(1, 0, 0, -Float.pi/4 * 0.75)
        eulerAngles = SCNVector3(
            x: -getRadianFor(degree: 30),
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
