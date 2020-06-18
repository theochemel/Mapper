import Foundation
import ARKit

public struct Mesh: Codable {
    
    var vertices: [[simd_float3]]
    var normals: [[simd_float3]]
    var faces: [[simd_uint3]]
    
    init(from anchors: [ARMeshAnchor]) {
        self.vertices = []
        self.normals = []
        self.faces = []
        
        for anchor in anchors {
            let anchor = anchor.copy() as! ARMeshAnchor
                        
            var vertices: [simd_float3] = []
            let verticesPointer = anchor.geometry.vertices.buffer.contents()
            for i in 0 ..< anchor.geometry.vertices.count {
                let pointer = verticesPointer.advanced(by: i * anchor.geometry.vertices.stride + anchor.geometry.vertices.offset)
                var vertex = simd_float3()
                vertex.x = pointer.assumingMemoryBound(to: Float32.self).pointee
                vertex.y = pointer.advanced(by: MemoryLayout<Float32>.size).assumingMemoryBound(to: Float32.self).pointee
                vertex.z = pointer.advanced(by: MemoryLayout<Float32>.size * 2).assumingMemoryBound(to: Float32.self).pointee
                vertex += simd_float3(anchor.transform.columns.3[0], anchor.transform.columns.3[1], anchor.transform.columns.3[2])
                vertices.append(vertex)
            }
            
            var normals: [simd_float3] = []
            let normalsPointer = anchor.geometry.normals.buffer.contents()
            for i in 0 ..< anchor.geometry.normals.count {
                let pointer = normalsPointer.advanced(by: i * anchor.geometry.normals.stride + anchor.geometry.normals.offset)
                var normal = simd_float3()
                normal.x = pointer.assumingMemoryBound(to: Float32.self).pointee
                normal.y = pointer.advanced(by: MemoryLayout<Float32>.size).assumingMemoryBound(to: Float32.self).pointee
                normal.z = pointer.advanced(by: MemoryLayout<Float32>.size * 2).assumingMemoryBound(to: Float32.self).pointee
                normals.append(normal)
            }
            
            var faces: [simd_uint3] = []
            let facesPointer = anchor.geometry.faces.buffer.contents()
            for i in stride(from: 0, through: anchor.geometry.faces.count - 3, by: anchor.geometry.faces.indexCountPerPrimitive) {
                let pointer = facesPointer.advanced(by: i * anchor.geometry.faces.bytesPerIndex)
                var face = simd_uint3()
                face.x = pointer.assumingMemoryBound(to: UInt32.self).pointee
                face.y = pointer.advanced(by: MemoryLayout<UInt32>.size).assumingMemoryBound(to: UInt32.self).pointee
                face.z = pointer.advanced(by: MemoryLayout<UInt32>.size * 2).assumingMemoryBound(to: UInt32.self).pointee
                faces.append(face)
            }
            
            self.vertices.append(vertices)
            self.normals.append(normals)
            self.faces.append(faces)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case vertices
        case normals
        case faces
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.vertices = try container.decode([[simd_float3]].self, forKey: .vertices)
        self.normals = try container.decode([[simd_float3]].self, forKey: .normals)
        self.faces = try container.decode([[simd_uint3]].self, forKey: .faces)
    }
}
