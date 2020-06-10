import Foundation
import ARKit

class Plane {
    var id: UUID
    var classification: Classification
    var alignment: Alignment
    var position: simd_float3
    var rotation: simd_quatf
    var extent: simd_float2
    var vertices: [simd_float3]
    var triangleIndices: [simd_int3]
    var boundaryVertices: [simd_float3]
    var transform: [simd_float4]
    
    init(anchor: ARPlaneAnchor) {
        self.id = anchor.identifier
        self.classification = Classification(anchorClassification: anchor.classification)
        self.alignment = Alignment(anchorAlignment: anchor.alignment)
        
        self.position = anchor.center
        self.rotation = simd_quatf(anchor.transform)
        self.extent = simd_float2(x: anchor.extent.x, y: anchor.extent.z)
        self.vertices = anchor.geometry.vertices
        
        self.triangleIndices = []
        
        for i in 0 ..< anchor.geometry.triangleCount {
            self.triangleIndices.append(simd_int3(Int32(anchor.geometry.triangleIndices[i * 3]),
                                                  Int32(anchor.geometry.triangleIndices[i * 3 + 1]),
                                                  Int32(anchor.geometry.triangleIndices[i * 3 + 2])))
        }
        
        self.boundaryVertices = anchor.geometry.boundaryVertices
        self.transform = [anchor.transform.columns.0, anchor.transform.columns.1, anchor.transform.columns.2, anchor.transform.columns.3]
    }
    
    public func update(from anchor: ARPlaneAnchor) {
        self.classification = Classification(anchorClassification: anchor.classification)
        self.alignment = Alignment(anchorAlignment: anchor.alignment)

        self.position = anchor.center
        self.rotation = simd_quatf(anchor.transform)
        self.extent = simd_float2(x: anchor.extent.x, y: anchor.extent.z)
        self.vertices = anchor.geometry.vertices
        
        self.triangleIndices = []
        
        for i in 0 ..< anchor.geometry.triangleCount {
            self.triangleIndices.append(simd_int3(Int32(anchor.geometry.triangleIndices[i * 3]),
                                                  Int32(anchor.geometry.triangleIndices[i * 3 + 1]),
                                                  Int32(anchor.geometry.triangleIndices[i * 3 + 2])))
        }
        
        self.boundaryVertices = anchor.geometry.boundaryVertices
        self.transform = [anchor.transform.columns.0, anchor.transform.columns.1, anchor.transform.columns.2, anchor.transform.columns.3]
    }
    
    public func shouldBeTreatedAsWall() -> Bool {
        return self.alignment == .vertical
    }
}

extension Plane {
    enum Classification: String, Codable {
        case wall
        case floor
        case ceiling
        case table
        case seat
        case door
        case window
        case unknown
        
        init(anchorClassification: ARPlaneAnchor.Classification) {
            switch anchorClassification {
            case .wall: self = .wall
            case .floor: self = .floor
            case .ceiling: self = .ceiling
            case .table: self = .table
            case .seat: self = .seat
            case .door: self = .door
            case .window: self = .window
            default: self = .unknown
            }
        }
    }
}

extension Plane {
    enum Alignment: String, Codable {
        case horizontal
        case vertical
        case unknown
        
        init(anchorAlignment: ARPlaneAnchor.Alignment) {
            switch anchorAlignment {
            case .horizontal: self = .horizontal
            case .vertical: self = .vertical
            @unknown default:
                self = .unknown
            }
        }
    }
}
