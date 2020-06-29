import Foundation
import CoreData

extension Wall: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case points
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.points, forKey: .points)
    }
    
    public convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError("Couldn't get context.") }
        guard let entity = NSEntityDescription.entity(forEntityName: "Wall", in: context) else { fatalError("Couldn't get entity.") }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.points = try container.decode([UUID].self, forKey: .points)
    }
}
