import Foundation
import RealityKit
import ARKit

class ScanState {
    public var cameraPosition: vector_float3
    public var cameraOrientation: vector_float3
    public var planes: [UUID: Plane]
    
    public init() {
        self.cameraPosition = vector_float3(0.0, 0.0, 0.0)
        self.cameraOrientation = vector_float3(0.0, 0.0, 0.0)
        self.planes = [:]
    }
    
    public func reset() {
        self.cameraPosition = vector_float3(0.0, 0.0, 0.0)
        self.cameraOrientation = vector_float3(0.0, 0.0, 0.0)
        self.planes = [:]
    }
    
    public func update(from frame: ARFrame) {
        let column = frame.camera.transform.columns.3
        
        self.cameraPosition = vector_float3(column.x, column.y, column.z)
        self.cameraOrientation = frame.camera.eulerAngles
    }
    
    func addPlane(from anchor: ARPlaneAnchor) -> Plane {
        self.planes[anchor.identifier] = Plane(anchor: anchor)
        return self.planes[anchor.identifier]!
    }
    
    func updatePlane(from anchor: ARPlaneAnchor) -> Plane {
        if let plane = self.planes[anchor.identifier] {
            self.planes[anchor.identifier]?.update(from: anchor)
            return self.planes[anchor.identifier]!
        } else {
            return self.addPlane(from: anchor)
        }
    }
    
    func removePlane(from anchor: ARPlaneAnchor) {
        self.planes[anchor.identifier] = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case planes
        case cameraPosition = "camera_position"
        case cameraOrientation = "camera_orientation"
    }
    
    func encode(to encoder: Encoder) throws {
        var stringKeyedPlanes: [String: Plane] = [:]
        _ = self.planes.map { stringKeyedPlanes[$0.0.uuidString] = $0.1 }
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.cameraPosition, forKey: .cameraPosition)
        try container.encode(self.cameraOrientation, forKey: .cameraOrientation)
//        try container.encode(stringKeyedPlanes, forKey: .planes)
    }
}
