import Foundation
import ARKit

extension ScanRecorder: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = self.scanState.addPlane(from: planeAnchor)
            
            if plane.shouldBeTreatedAsWall() {
                let wallNode = WallNode(for: plane)
                wallNode.eulerAngles.x = -.pi/2

//                node.addChildNode(wallNode)
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
                guard let wallNode = node.childNodes.first(where: { $0 is WallNode }) as? WallNode else { return }
                wallNode.update(from: plane)
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
        }
    }
}
