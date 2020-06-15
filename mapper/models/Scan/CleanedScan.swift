import Foundation
import CoreData

public final class CleanedScan: Codable {

    var mesh: Mesh
    
    public init(mesh: Mesh) {
        self.mesh = mesh
    }
    
    enum CodingKeys: String, CodingKey {
        case mesh
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.mesh, forKey: CodingKeys.mesh.rawValue)
    }
    
    convenience public init(coder: NSCoder) {
        let mesh = coder.decodeObject(forKey: CodingKeys.mesh.rawValue) as! Mesh
        
        self.init(mesh: mesh)
    }
}
