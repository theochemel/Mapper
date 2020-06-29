import Foundation
import ARKit
import CoreData

class ObjectPlacementManager {
    
    public var context: NSManagedObjectContext!
    
    var category: Object.Category
    
    weak var arViewProvider: ARViewProvider!
    weak var delegate: ObjectPlacementManagerDelegate?
    
    var cursor: CursorNode?
    var boundAxis: BoundAxis?
    
    init(for category: Object.Category, context: NSManagedObjectContext) {
        self.context = context
        self.category = category
    }
    
    public func start() {
        self.cursor = CursorNode()
        self.arViewProvider.arView.pointOfView?.addChildNode(cursor!)
        cursor?.position = SCNVector3(0.0, 0.0, -1.0)
        // show cursor
    }
    
    public func stop() {
        // remove nodes if placement is unfinished
        self.cursor?.removeFromParentNode()
        self.cursor = nil
    }
    
    public func moveCursor(toDistance distance: CGFloat) {
        SCNTransaction.animationDuration = 0.1
        self.cursor?.position = SCNVector3(0.0, 0.0, -distance)
    }
    
    public func rotateCursor(to orientation: SCNQuaternion, distance: CGFloat) {
        guard let cursor = self.cursor else { return }
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.20
        cursor.position = SCNVector3(0.0, 0.0, -distance)
        if let boundAxis = self.boundAxis {
            cursor.simdWorldPosition = boundAxis.boundVector(cursor.simdWorldPosition)
        }
        SCNTransaction.commit()
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.25
        cursor.worldOrientation = orientation
        SCNTransaction.commit()
    }
    
    public func rotateCursorTowardsCamera(distance: CGFloat) {
        guard let cursor = self.cursor else { return }
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.20
        self.cursor?.position = SCNVector3(0.0, 0.0, -distance)
        if let boundAxis = self.boundAxis {
            cursor.simdWorldPosition = boundAxis.boundVector(cursor.simdWorldPosition)
        }
        SCNTransaction.commit()
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.25
        cursor.eulerAngles = SCNVector3(.pi / 2.0, 0.0, 0.0)
        SCNTransaction.commit()
    }
    
    public func addPoint() {
        
    }
    
    public func getCurrentCursorPosition() -> simd_float3? {
        let hitTestResults = self.arViewProvider.arView.hitTest(self.arViewProvider.arView.center, types: [.existingPlaneUsingExtent, .featurePoint])
        
        if let result = hitTestResults.first {
            let column = result.worldTransform.columns.3
            let position = simd_float3(column[0], column[1], column[2])
            return position
        }
        return nil
    }
    
    public func getCurrentCursorPlaneID() -> UUID? {
        let hitTestResults = self.arViewProvider.arView.hitTest(self.arViewProvider.arView.center, types: [.existingPlaneUsingExtent])
        
        return (hitTestResults.first?.anchor as? ARPlaneAnchor)?.identifier
    }
    
    public func getHorizontalAxisPerpendicularToDevice() -> BoundAxis.Axis? {
        guard let orientation = self.arViewProvider.arView.pointOfView?.simdEulerAngles else { return nil }
        
        var roundedOrientation = (orientation / (Float.pi / 2.0) + (Float.pi / 4.0)).rounded(.toNearestOrAwayFromZero)
        roundedOrientation *= (Float.pi / 2.0)
        
        if [-Float.pi, 0.0, Float.pi].contains(roundedOrientation.y) {
            return .x
        } else {
            return .z
        }
    }
}
