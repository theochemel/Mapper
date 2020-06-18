import Foundation
import ARKit

final class Wall: Codable {
    var id: UUID
    var start: Point
    var end: Point
    
    enum CodingKeys: String, CodingKey {
        case id
        case start
        case end
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.start, forKey: .start)
        try container.encode(self.end, forKey: .end)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.start = try container.decode(Point.self, forKey: .start)
        self.end = try container.decode(Point.self, forKey: .end)
    }
}
