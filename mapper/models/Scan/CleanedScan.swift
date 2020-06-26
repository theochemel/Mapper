import Foundation
import CoreData
import SceneKit.ModelIO

public final class CleanedScan: Codable {

    var floorplan: Floorplan?
    var reconstruction: Reconstruction?
    var mesh: Mesh
    var pointCloud: PointCloud?
    
    public init(mesh: Mesh) {
        self.mesh = mesh
    }
    
    enum CodingKeys: String, CodingKey {
        case floorplan
        case mesh
        case reconstruction
        case pointCloud = "point_cloud"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.floorplan, forKey: .floorplan)
        try container.encode(self.mesh, forKey: .mesh)
        try container.encode(self.reconstruction, forKey: .reconstruction)
        try container.encode(self.pointCloud, forKey: .pointCloud)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.floorplan = try container.decode(Floorplan?.self, forKey: .floorplan)
        self.mesh = try container.decode(Mesh.self, forKey: .mesh)
        self.reconstruction = try container.decode(Reconstruction?.self, forKey: .reconstruction)
        self.pointCloud = try container.decode(PointCloud.self, forKey: .pointCloud)
    }
}
