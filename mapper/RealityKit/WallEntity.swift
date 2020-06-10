import Foundation
import RealityKit
import UIKit

class WallEntity: Entity, HasModel {
    
    public init(plane: Plane) {
        super.init()
        
        self.model = ModelComponent(
            mesh: .generatePlane(width: plane.extent.x, depth: plane.extent.y),
            materials: [
                SimpleMaterial(color: UIColor.systemBlue.withAlphaComponent(0.5), isMetallic: false)
            ]
        )
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    public func update(from plane: Plane) {
        self.model = ModelComponent(
            mesh: .generatePlane(width: plane.extent.x, depth: plane.extent.y),
            materials: [
                SimpleMaterial(color: UIColor.systemBlue.withAlphaComponent(0.5), isMetallic: false)
            ]
        )
    }
}
