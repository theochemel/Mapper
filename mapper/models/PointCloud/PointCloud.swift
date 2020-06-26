import Foundation
import ARKit

public final class PointCloud: Codable {
    var points: [simd_float3]
    var colors: [SIMD3<UInt8>]
    
    public init() {
        self.points = []
        self.colors = []
    }
    
    enum CodingKeys: String, CodingKey {
        case count
        case points
        case colors
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.points.count, forKey: .count)
        
        var pointsData = Data(count: self.points.count * 12)
        var colorsData = Data(count: self.points.count * 3)
        
        for i in 0..<self.points.count {
            pointsData.replaceSubrange(i..<i+12, with: withUnsafePointer(to: self.points[i]) { Data(bytes: $0, count: 12) })
            colorsData.replaceSubrange(i..<i+4, with: withUnsafePointer(to: self.colors[i]) { Data(bytes: $0, count: 12) })
        }
        
        try container.encode(pointsData, forKey: .points)
        try container.encode(colorsData, forKey: .colors)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let count = try container.decode(Int.self, forKey: .count)
        let pointsData = try container.decode(Data.self, forKey: .points)
        let colorsData = try container.decode(Data.self, forKey: .colors)
        
        self.points = []
        self.points.reserveCapacity(count)
        self.colors = []
        self.colors.reserveCapacity(count)
        
        for i in 0..<count {
            self.points.append(simd_float3(x: withUnsafeBytes(of: pointsData[i*12..<(i*12)+4]) { $0.load(as: Float.self) },
                                           y: withUnsafeBytes(of: pointsData[i*12+5..<(i*12)+8]) { $0.load(as: Float.self) },
                                           z: withUnsafeBytes(of: pointsData[i*12+9..<(i*12)+12]) { $0.load(as: Float.self) }))
            self.colors.append(SIMD3<UInt8>(x: withUnsafeBytes(of: colorsData[i*3]) { $0.load(as: UInt8.self) },
                                            y: withUnsafeBytes(of: colorsData[i*3+1]) { $0.load(as: UInt8.self) },
                                            z: withUnsafeBytes(of: colorsData[i*3+2]) { $0.load(as: UInt8.self) }))
        }
    }
}
