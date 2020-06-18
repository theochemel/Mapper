import Foundation
import ARKit

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
