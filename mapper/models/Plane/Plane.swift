import Foundation
import ARKit

public final class Plane: Codable {
    var id: UUID
    var classification: Classification
    var alignment: Alignment
    var geometry: Geometry
    var position: simd_float3
    var rotation: simd_quatf
    var extent: simd_float3
    
    init(anchor: ARPlaneAnchor) {
        self.id = anchor.identifier
        self.classification = Classification(from: anchor.classification)
        self.alignment = Alignment(from: anchor.alignment)
        self.geometry = Geometry(from: anchor.geometry)
        
        self.rotation = simd_quatf(anchor.transform)
        self.position = simd_float3(anchor.transform[3][0], anchor.transform[3][1], anchor.transform[3][2]) + self.rotation.act(anchor.center)
        self.extent = anchor.extent
    }
    
    public func update(from anchor: ARPlaneAnchor) {
        self.classification = Classification(from: anchor.classification)
        self.alignment = Alignment(from: anchor.alignment)
        self.geometry = Geometry(from: anchor.geometry)

        self.rotation = simd_quatf(anchor.transform)
        self.position = simd_float3(anchor.transform[3][0], anchor.transform[3][1], anchor.transform[3][2]) + self.rotation.act(anchor.center)
        self.extent = anchor.extent
    }
    
    public func shouldBeTreatedAsWall() -> Bool {
//        return self.alignment == .vertical
        return self.classification == .wall
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case classification
        case alignment
        case geometry
        case position
        case rotation
        case extent
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.classification, forKey: .classification)
        try container.encode(self.alignment, forKey: .alignment)
        try container.encode(self.geometry, forKey: .geometry)
        try container.encode(self.position, forKey: .position)
        try container.encode(self.rotation.vector, forKey: .rotation)
        try container.encode(self.extent, forKey: .extent)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.classification = try container.decode(Classification.self, forKey: .classification)
        self.alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.geometry = try container.decode(Geometry.self, forKey: .geometry)
        self.position = try container.decode(simd_float3.self, forKey: .position)

        let rotationVector = try container.decode(simd_float4.self, forKey: .rotation)
        self.rotation = simd_quatf(vector: rotationVector)
        
        self.extent = try container.decode(simd_float3.self, forKey: .extent)
    }
}
