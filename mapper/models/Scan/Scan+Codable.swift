import Foundation
import CoreData

extension Scan: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case dateCreated = "date_created"
        case address
        case floor
        case rawFloorplan = "raw_floorplan"
        case floorplan
        case reconstruction
        case pointCloud = "point_cloud"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.floor, forKey: .floor)
        try container.encode(self.rawFloorplan, forKey: .rawFloorplan)
        try container.encode(self.floorplan, forKey: .floorplan)
        try container.encode(self.reconstruction, forKey: .reconstruction)
        try container.encode(self.pointCloud, forKey: .pointCloud)
    }
    
    public convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError("Couldn't get context.") }
        guard let entity = NSEntityDescription.entity(forEntityName: "Scan", in: context) else { fatalError("Couldn't get entity.") }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.address = try container.decode(String.self, forKey: .address)
        self.floor = try container.decode(String.self, forKey: .floor)
        self.rawFloorplan = try container.decode(RawFloorplan?.self, forKey: .rawFloorplan)
        self.floorplan = try container.decode(Floorplan?.self, forKey: .floorplan)
        self.reconstruction = try container.decode(Reconstruction?.self, forKey: .reconstruction)
        self.pointCloud = try container.decode(PointCloud?.self, forKey: .pointCloud)
    }
}
