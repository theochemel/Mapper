import Foundation
import CoreData

extension Object: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case position
        case extent
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.position, forKey: .position)
        try container.encode(self.extent, forKey: .extent)
    }
    
    public convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError("Couldn't get context.") }
        guard let entity = NSEntityDescription.entity(forEntityName: "Object", in: context) else { fatalError("Couldn't get entity.") }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.category = try container.decode(Category.self, forKey: .category)
        self.position = try container.decode(simd_float3.self, forKey: .position)
        self.extent = try container.decode(simd_float3.self, forKey: .extent)
    }
}
