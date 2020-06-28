import Foundation
import CoreData
import SceneKit

public final class CleanedScan: Codable {

    var floorplan: Floorplan?
    var reconstruction: Reconstruction?
    var pointCloud: PointCloud?
    
    enum CodingKeys: String, CodingKey {
        case floorplan
        case reconstruction
        case pointCloud = "point_cloud"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.floorplan, forKey: .floorplan)
        try container.encode(self.reconstruction, forKey: .reconstruction)
        try container.encode(self.pointCloud, forKey: .pointCloud)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.floorplan = try container.decode(Floorplan?.self, forKey: .floorplan)
        self.reconstruction = try container.decode(Reconstruction?.self, forKey: .reconstruction)
        self.pointCloud = try container.decode(PointCloud.self, forKey: .pointCloud)
    }
}
