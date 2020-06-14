import Foundation
import ARKit

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
        
        init(from anchorClassification: ARPlaneAnchor.Classification) {
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
