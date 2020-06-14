import Foundation
import SceneKit

class CursorNode: SCNNode {
    
    static var cursorMaterial: SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemBlue
        material.lightingModel = .physicallyBased
        material.readsFromDepthBuffer = false
        return material
    }
    
    override init() {
        super.init()
        
        self.name = "cursor"
        self.geometry = SCNSphere(radius: 0.01)
        self.geometry?.firstMaterial = CursorNode.cursorMaterial
        
        let ring = SCNNode(geometry: SCNTorus(ringRadius: 0.04, pipeRadius: 0.005))
        ring.geometry?.firstMaterial = CursorNode.cursorMaterial
        self.addChildNode(ring)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showError() {
        SCNTransaction.animationDuration = 0.1
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.systemRed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            SCNTransaction.animationDuration = 0.1
            self.geometry?.firstMaterial?.diffuse.contents = UIColor.systemBlue
        }
    }
}
