import Foundation
import CoreData

extension Reconstruction: Codable {
    
    enum CodingKeys: String, CodingKey {
        case ifcFileData = "ifc_data"
        case objFileData = "obj_data"
        case objMtlFileData = "obj_mtl_data"
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
    
    public convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError("Couldn't get context.") }
        guard let entity = NSEntityDescription.entity(forEntityName: "PointCloud", in: context) else { fatalError("Couldn't get entity.") }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let ifcFileData = try container.decode(Data.self, forKey: .ifcFileData)
        let objFileData = try container.decode(Data.self, forKey: .objFileData)
        let objMtlFileData = try container.decode(Data.self, forKey: .objMtlFileData)
    }
}
