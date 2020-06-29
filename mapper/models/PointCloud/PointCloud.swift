import Foundation
import ARKit
import CoreData

@objc(PointCloud)
public final class PointCloud: NSManagedObject {
    
    @NSManaged var pointCount: Int
    @NSManaged var pointsData: Data
    @NSManaged var colorsData: Data
    @NSManaged var plyFilePath: URL?
    
    public var points: [simd_float3] {
        get {
            var p: [simd_float3] = []
            guard self.pointCount > 0 else { return p }

            p.reserveCapacity(self.pointCount)
            
            for i in 0..<self.pointCount {
                p.append(simd_float3(x: self.pointsData[i * 12 ..< i * 12 + 4].withUnsafeBytes { $0.load(as: Float.self) },
                                          y: self.pointsData[i * 12 + 4 ..< i * 12 + 8].withUnsafeBytes { $0.load(as: Float.self) },
                                          z: self.pointsData[i * 12 + 8 ..< i * 12 + 12].withUnsafeBytes { $0.load(as: Float.self) }))
            }
            
            return p
        }
    }
    
    public var colors: [simd_uchar3] {
        get {
            var c: [simd_uchar3] = []

            guard self.pointCount > 0 else { return c }

            c.reserveCapacity(self.pointCount)

            for i in 0..<self.pointCount {
                c.append(simd_uchar3(x: self.colorsData[i * 3],
                                          y: self.colorsData[i * 3 + 1],
                                          z: self.colorsData[i * 3 + 2]))
            }
            
            return c
        }
    }
    
    public func addPoints(_ points: [simd_float3], colors: [simd_float3]) {
        guard points.count == colors.count else { fatalError("Mismatch between point count and color count.") }
                
        for (point, color) in zip(points, colors) {
            self.addPoint(point, color: color)
        }
    }
    
    public func addPoint(_ point: simd_float3, color: simd_float3) {
        self.pointCount += 1
        
        self.pointsData.append(withUnsafeBytes(of: point.x) { Data($0) })
        self.pointsData.append(withUnsafeBytes(of: point.y) { Data($0) })
        self.pointsData.append(withUnsafeBytes(of: point.z) { Data($0) })
        
        let red = Int(color.x * 255.0)
        let green = Int(color.y * 255.0)
        let blue = Int(color.z * 255.0)
        
        self.colorsData.append(contentsOf: [UInt8(clamping: red), UInt8(clamping: green), UInt8(clamping: blue)])
    }
}
