import Foundation
import ARKit

public class Object: Codable {
    var id: UUID
    var planeID: UUID?
    var category: Category
    var position: simd_float3
    var extent: simd_float3
    
    init(planeID: UUID?, position: simd_float3, extent: simd_float3, category: Category) {
        self.id = UUID()
        self.planeID = planeID
        self.position = position
        self.extent = extent
        self.category = category
    }
}
