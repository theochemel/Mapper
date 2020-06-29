import Foundation
import ARKit

class WallBox2DPlacementManager: ObjectPlacementManager {
    
    var planeID: UUID?
    var points: [simd_float3] = []
    
    override func addPoint() {
        
        if let position = super.getCurrentCursorPosition() {
            
            if points.count == 0 {
                guard let perpAxis = super.getHorizontalAxisPerpendicularToDevice() else {
                    self.cursor?.showError()
                    return
                }
                
                self.boundAxis = BoundAxis(perpAxis, perpAxis.value(from: position))
                
                self.planeID = super.getCurrentCursorPlaneID()
            }
            
            self.points.append(position)
            
            if points.count == 2 {
                let center = (self.points[0] + self.points[1]) / 2.0
                let extent = abs(self.points[0] - self.points[1])
                
                let object = Object(context: self.context)
                object.category = self.category
                object.position = center
                object.extent = extent
                self.delegate?.didAddObject(object)
                let objectNode = ObjectNode(for: object)
                self.arViewProvider.arView.scene.rootNode.addChildNode(objectNode)
            }
            
        } else {
            self.cursor?.showError()
        }
    }
    
}
