import Foundation
import ARKit

public final class PointCloud: Codable {
    var points: [simd_float3]
    var colors: [simd_float3]
    var plyPath: URL?
    
    public init() {
        self.points = []
        self.colors = []
    }
    
    enum CodingKeys: String, CodingKey {
        case count
        case points
        case colors
    }
    
    public func export() {
        do {
            let plyTempPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension(".ply")
            var file = """
            ply
            format ascii 1.0
            comment author: Theo C.
            element vertex \(self.points.count)
            property float x
            property float y
            property float z
            property uchar red
            property uchar green
            property uchar blue
            end_header\n
            """
            
            for i in 0..<self.points.count {
                var red = Int(self.colors[i].x * 255)
                var green = Int(self.colors[i].y * 255)
                var blue = Int(self.colors[i].z * 255)
                
                if red < 0 {
                    red = 0
                } else if red > 255 {
                    red = 255
                }
                
                if green < 0 {
                    green = 0
                } else if green > 255 {
                    green = 255
                }
                
                if blue < 0 {
                    blue = 0
                } else if blue > 255 {
                    blue = 255
                }
                
                file.append("\(self.points[i].x) \(self.points[i].y) \(self.points[i].z) \(red) \(green) \(blue)\n")
            }
            try file.write(to: plyTempPath, atomically: true, encoding: .utf8)
            
            self.plyPath = plyTempPath
        } catch(let error) {
            print(error)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.points.count, forKey: .count)
        
        var pointsData = Data(count: self.points.count * 12)
        var colorsData = Data(count: self.points.count * 12)
        
        for i in 0..<self.points.count {
            pointsData.replaceSubrange(i*12..<i*12+4, with: withUnsafeBytes(of: self.points[i].x) { Data($0) })
            pointsData.replaceSubrange(i*12+4..<i*12+8, with: withUnsafeBytes(of: self.points[i].y) { Data($0) })
            pointsData.replaceSubrange(i*12+8..<i*12+12, with: withUnsafeBytes(of: self.points[i].z) { Data($0) })
            colorsData.replaceSubrange(i*12..<i*12+4, with: withUnsafeBytes(of: self.colors[i].x) { Data($0) })
            colorsData.replaceSubrange(i*12+4..<i*12+8, with: withUnsafeBytes(of: self.colors[i].y) { Data($0) })
            colorsData.replaceSubrange(i*12+8..<i*12+12, with: withUnsafeBytes(of: self.colors[i].z) { Data($0) })
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
            self.points.append(simd_float3(x: pointsData[i * 12 ..< i * 12 + 4].withUnsafeBytes { $0.load(as: Float.self) },
                                           y: pointsData[i * 12 + 4 ..< i * 12 + 8].withUnsafeBytes { $0.load(as: Float.self) },
                                           z: pointsData[i * 12 + 8 ..< i * 12 + 12].withUnsafeBytes { $0.load(as: Float.self) }))
            self.colors.append(simd_float3(x: colorsData[i * 12 ..< i * 12 + 4].withUnsafeBytes { $0.load(as: Float.self) },
                                           y: colorsData[i * 12 + 4 ..< i * 12 + 8].withUnsafeBytes { $0.load(as: Float.self) },
                                           z: colorsData[i * 12 + 8 ..< i * 12 + 12].withUnsafeBytes { $0.load(as: Float.self) }))
        }
    }
}
