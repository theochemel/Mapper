import Foundation

enum ObjectType: CaseIterable {
    case table
    case chair
    case bed
    case couch
}

class Object {
    enum Category: CaseIterable {
        case table
        case chair
        case bed
        case couch
    }
    
    static func displayName(for category: Category) -> String {
        switch category {
        case .table: return "Table"
        case .chair: return "Chair"
        case .bed: return "Bed"
        case .couch: return "Couch"
        }
    }
}
