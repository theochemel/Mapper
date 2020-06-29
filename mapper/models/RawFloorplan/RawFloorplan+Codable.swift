import Foundation
import CoreData

extension RawFloorplan: Codable {
    
    enum CodingKeys: String, CodingKey {
        case planes
        case objects
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.planes, forKey: .planes)
        try container.encode(self.objects, forKey: .objects)
    }
    
    public convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError("Couldn't get context.") }
        guard let entity = NSEntityDescription.entity(forEntityName: "RawFloorplan", in: context) else { fatalError("Couldn't get entity.") }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.planes = try container.decode(Set<Plane>.self, forKey: .planes)
        self.objects = try container.decode(Set<Object>.self, forKey: .objects)
    }
}
