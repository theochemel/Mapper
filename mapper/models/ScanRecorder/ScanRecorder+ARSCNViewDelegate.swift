import Foundation
import ARKit

extension ScanRecorder: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = self.scanState.addPlane(from: planeAnchor)
            
            if plane.shouldBeTreatedAsWall() {
                self.wallNode?.addPlane(planeAnchor)
            }
        }
        
        if let meshAnchor = anchor as? ARMeshAnchor {
            let occlusionNode = OcclusionNode(for: meshAnchor)
            node.addChildNode(occlusionNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = self.scanState.updatePlane(from: planeAnchor)
            
            if plane.shouldBeTreatedAsWall() {
                self.wallNode?.updatePlane(planeAnchor)
            } else {
                self.wallNode?.removePlane(withID: plane.id)
            }
        }
        if let meshAnchor = anchor as? ARMeshAnchor {
            if let occlusionNode = node.childNode(withName: "occlusion", recursively: true) as? OcclusionNode {
                occlusionNode.update(from: meshAnchor)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            self.scanState.removePlane(from: planeAnchor)
            
            self.wallNode?.removePlane(withID: planeAnchor.identifier)
        }
    }
}
