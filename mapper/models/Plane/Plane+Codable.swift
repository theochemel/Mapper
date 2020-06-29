import Foundation
import CoreData

extension Plane: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case classification
        case alignment
        case geometry
        case position
        case rotation
        case extent
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.classification, forKey: .classification)
        try container.encode(self.alignment, forKey: .alignment)
        try container.encode(self.position, forKey: .position)
        try container.encode(self.rotation.vector, forKey: .rotation)
        try container.encode(self.extent, forKey: .extent)
    }

    public convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError("Couldn't get context.") }
        guard let entity = NSEntityDescription.entity(forEntityName: "Plane", in: context) else { fatalError("Couldn't get entity.") }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.classification = try container.decode(Classification.self, forKey: .classification)
        self.alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.position = try container.decode(simd_float3.self, forKey: .position)
        
        let rotationVector = try container.decode(simd_float4.self, forKey: .rotation)
        self.rotation = simd_quatf(vector: rotationVector)
        
        self.extent = try container.decode(simd_float3.self, forKey: .extent)
    }
}
