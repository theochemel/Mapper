import Foundation
import ARKit

public class Mesh: Codable {
    
    var vertices: [simd_float3]
    var normals: [simd_float3]
    var faces: [simd_uint3]
    
    init(from anchors: [ARMeshAnchor]) {
        self.vertices = [simd_float3]()
        self.normals = [simd_float3]()
        self.faces = [simd_uint3]()
        
        for anchor in anchors {
            
            let verticesPointer = anchor.geometry.vertices.buffer.contents()
            for i in 0 ..< anchor.geometry.vertices.count {
                let pointer = verticesPointer.advanced(by: i * MemoryLayout<simd_float3>.size)
                self.vertices.append(pointer.assumingMemoryBound(to: simd_float3.self).pointee)
            }
            
            let normalsPointer = anchor.geometry.normals.buffer.contents()
            for i in 0 ..< anchor.geometry.normals.count {
                let pointer = normalsPointer.advanced(by: i * MemoryLayout<simd_float3>.size)
                self.normals.append(pointer.assumingMemoryBound(to: simd_float3.self).pointee)
            }
            
            
            let facesPointer = anchor.geometry.faces.buffer.contents()
            for i in stride(from: 0, through: anchor.geometry.faces.count - 3, by: 3) {
                let pointer = facesPointer.advanced(by: i * MemoryLayout<simd_uint3>.size)
                self.faces.append(pointer.assumingMemoryBound(to: simd_uint3.self).pointee)
            }
        }
    }
}
