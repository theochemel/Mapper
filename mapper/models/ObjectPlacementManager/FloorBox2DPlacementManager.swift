import Foundation
import ARKit

class FloorBox2DPlacementManager: ObjectPlacementManager {
    
    var points: [simd_float3] = []
    
    override func addPoint() {
        
        if let position = super.getCurrentCursorPosition() {
            
            if points.count == 0 {
                self.boundAxis = BoundAxis(.y, position.y)
            }
            
            self.points.append(position)
            
            if points.count == 2 {
                let center = (self.points[0] + self.points[1]) / 2.0
                let extent = abs(self.points[0] - self.points[1])
                
                let object = Object(planeID: nil, position: center, extent: extent, category: self.category)
                self.delegate?.didAddObject(object)
                let objectNode = ObjectNode(for: object)
                self.arViewProvider.arView.scene.rootNode.addChildNode(objectNode)
            }
        } else {
            self.cursor?.showError()
        }
    }
}
