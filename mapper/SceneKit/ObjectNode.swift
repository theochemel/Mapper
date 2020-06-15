import Foundation
import SceneKit

class ObjectNode: SCNNode {
    
    static let objectNodeMaterial: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemBlue
        material.transparency = 0.6
        return material
    }()
    
    init(for object: Object) {
        super.init()

        self.geometry = SCNBox(width: CGFloat(object.extent.x < 0.1 ? 0.1 : object.extent.x), height: CGFloat(object.extent.y < 0.1 ? 0.1 : object.extent.y), length: CGFloat(object.extent.z < 0.1 ? 0.1 : object.extent.z), chamferRadius: 0.0)
        self.geometry?.firstMaterial = ObjectNode.objectNodeMaterial
        self.position = SCNVector3(object.position)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
