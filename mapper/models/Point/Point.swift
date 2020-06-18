import Foundation
import ARKit

public final class Point: Codable {
    var id: UUID
    var position: simd_float2
    
    enum CodingKeys: String, CodingKey {
        case id
        case position = "pos"
    }
}
