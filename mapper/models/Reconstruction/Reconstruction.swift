import Foundation
import SceneKit
import ModelIO

public final class Reconstruction: Codable {
    
    var objData: String
    var mtlData: String
    
    var asset: MDLAsset? {
        do {
            let objTempPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("obj")
            try self.objData.write(to: objTempPath, atomically: true, encoding: .utf8)
            
            let mtlTempPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("scan").appendingPathExtension("mtl")
            try self.objData.write(to: mtlTempPath, atomically: true, encoding: .utf8)
            
            let asset = MDLAsset(url: objTempPath)
            return asset
        } catch(let error) {
            print("Error creating reconstruction node: ", error)
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case objData = "obj_data"
        case mtlData = "mtl_data"
    }
}
