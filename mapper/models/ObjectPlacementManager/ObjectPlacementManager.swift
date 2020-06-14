import Foundation
import ARKit

class ObjectPlacementManager {
    var category: Object.Category
    
    weak var arViewProvider: ARViewProvider!
    weak var delegate: ObjectPlacementManagerDelegate?
    
    var cursor: CursorNode?
    var boundAxis: BoundAxis?
    
    init(for category: Object.Category) {
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
        SCNTransaction.animationDuration = 0.05
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
        SCNTransaction.animationDuration = 0.05
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

class WallBox2DPlacementManager: ObjectPlacementManager {
    
    var points: [simd_float3] = []
    
    override func addPoint() {
        
        if let position = super.getCurrentCursorPosition() {
            
            if points.count == 0 {
                guard let perpAxis = super.getHorizontalAxisPerpendicularToDevice() else {
                    self.cursor?.showError()
                    return
                }
                
                self.boundAxis = BoundAxis(perpAxis, perpAxis.value(from: position))
            }
            
            self.points.append(position)
            
            if points.count == 2 {
                let center = (self.points[0] + self.points[1]) / 2.0
                let extent = abs(self.points[0] - self.points[1])
                
                let object = Object(position: center, extent: extent, category: self.category)
                self.delegate?.didAddObject(object)
                let objectNode = ObjectNode(for: object)
                self.arViewProvider.arView.scene.rootNode.addChildNode(objectNode)
            }
            
        } else {
            self.cursor?.showError()
        }
    }
    
}

class FloorBox3DPlacementManager: ObjectPlacementManager {
    
}

extension ObjectPlacementManager {
    class BoundAxis {
        enum Axis {
            case x
            case y
            case z
            
            public func value(from vector: simd_float3) -> Float {
                switch self {
                    case .x: return vector.x
                    case .y: return vector.y
                    case .z: return vector.z
                }
            }
        }
        
        var axis: Axis
        var value: Float
        
        init(_ axis: Axis, _ value: Float) {
            self.axis = axis
            self.value = value
        }
        
        
        public func boundVector(_ vector: simd_float3) -> simd_float3 {
            var boundVector = vector
            switch self.axis {
                case .x: boundVector.x = self.value
                case .y: boundVector.y = self.value
                case .z: boundVector.z = self.value
            }
            return boundVector
        }
    }
}
