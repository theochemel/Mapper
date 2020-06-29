import Foundation
import CoreData

extension PointCloud: Codable {
    
    enum CodingKeys: String, CodingKey {
        case pointCount = "point_count"
        case pointsData = "points"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.pointCount, forKey: .pointCount)
        try container.encode(self.pointsData, forKey: .pointsData)
    }
    
    public convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError("Couldn't get context.") }
        guard let entity = NSEntityDescription.entity(forEntityName: "PointCloud", in: context) else { fatalError("Couldn't get entity.") }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.pointCount = try container.decode(Int.self, forKey: .pointCount)
        self.pointsData = try container.decode(Data.self, forKey: .pointsData)
    }
}
