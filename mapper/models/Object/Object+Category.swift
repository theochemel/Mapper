import Foundation

extension Object {
    enum Category: String, Codable, CaseIterable {
        case table = "table"
        case chair = "chair"
        case bed = "bed"
        case couch = "couch"
        case window = "window"
        case door = "door"
        
        func displayName() -> String {
            switch self {
            case .table: return "Table"
            case .chair: return "Chair"
            case .bed: return "Bed"
            case .couch: return "Couch"
            case .window: return "Window"
            case .door: return "Door"
            }
        }
        
        func placementCategory() -> PlacementCategory {
            if [.window, .door].contains(self) {
                return .wallBox2D
            } else {
                return .floorBox3D
            }
        }
    }
}
