import Foundation
import ARKit

extension Plane {
    public enum Alignment: String, Codable {
        case horizontal
        case vertical
        case unknown
        
        init(from anchorAlignment: ARPlaneAnchor.Alignment) {
            switch anchorAlignment {
            case .horizontal: self = .horizontal
            case .vertical: self = .vertical
            @unknown default:
                self = .unknown
            }
        }
    }
}
