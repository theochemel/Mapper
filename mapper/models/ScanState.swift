import Foundation
import RealityKit
import ARKit

class ScanState {
    public var cameraPosition: vector_float3
    public var cameraOrientation: vector_float3
    public var planes: [UUID: Plane]
    public var objects: [UUID: Object]
    
    public init() {
        self.cameraPosition = vector_float3(0.0, 0.0, 0.0)
        self.cameraOrientation = vector_float3(0.0, 0.0, 0.0)
        self.planes = [:]
        self.objects = [:]
    }
    
    public func reset() {
        self.cameraPosition = vector_float3(0.0, 0.0, 0.0)
        self.cameraOrientation = vector_float3(0.0, 0.0, 0.0)
        self.objects = [:]
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
            plane.update(from: anchor)
            return plane
        } else {
            return self.addPlane(from: anchor)
        }
    }
    
    func removePlane(from anchor: ARPlaneAnchor) {
        self.planes[anchor.identifier] = nil
    }
    
    func addObject(_ object: Object) {
        self.objects[object.id] = object
    }
    
    func removeObject(withID id: UUID) {
        self.objects[id] = nil
    }
}
