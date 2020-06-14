import Foundation
import ARKit

extension Plane {
    class Geometry: Codable {
        var vertices: [simd_float3]
        var boundaryVertices: [simd_float3]
        var triangles: [simd_int3]
        
        init(vertices: [simd_float3], boundaryVertices: [simd_float3], triangles: [simd_int3]) {
            self.vertices = vertices
            self.boundaryVertices = boundaryVertices
            self.triangles = triangles
        }
        
        init(from geometry: ARPlaneGeometry) {
            self.vertices = geometry.vertices
            self.boundaryVertices = geometry.boundaryVertices
            
            self.triangles = []
            for i in 0 ..< geometry.triangleCount {
                self.triangles.append(simd_int3(Int32(geometry.triangleIndices[i * 3]),
                                                      Int32(geometry.triangleIndices[i * 3 + 1]),
                                                      Int32(geometry.triangleIndices[i * 3 + 2])))
            }
        }
    }
}
