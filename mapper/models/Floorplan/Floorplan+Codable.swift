import Foundation
import CoreData

extension Floorplan: Codable {
    
    enum CodingKeys: String, CodingKey {
        case points
        case walls
        case objects
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.points, forKey: .points)
        try container.encode(self.walls, forKey: .walls)
        try container.encode(self.objects, forKey: .objects)
    }
    
    public convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError("Couldn't get context.") }
        guard let entity = NSEntityDescription.entity(forEntityName: "Floorplan", in: context) else { fatalError("Couldn't get entity.") }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.points = try container.decode(Set<Point>.self, forKey: .points)
        self.walls = try container.decode(Set<Wall>.self, forKey: .walls)
        self.objects = try container.decode(Set<Object>.self, forKey: .objects)
    }
}
