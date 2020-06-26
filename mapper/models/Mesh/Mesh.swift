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
        case verticesCount = "vertices_count"
        case vertices
        case normalsCount = "normals_count"
        case normals
        case facesCount = "faces_count"
        case faces
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var verticesCount = 0
        var vertices: [Float32] = []
        var normalsCount = 0
        var normals: [Float32] = []
        var facesCount = 0
        var faces: [UInt32] = []
        
        var verticesOffset = 0
        
        for i in 0..<self.vertices.count {
            let verticesSet = self.vertices[i]
            let normalsSet = self.normals[i]
            let facesSet = self.faces[i]
            
            verticesCount += verticesSet.count
            _ = verticesSet.map {
                vertices.append($0.x)
                vertices.append($0.y)
                vertices.append($0.z)
            }
            
            normalsCount += normalsSet.count
            _ = normalsSet.map {
                normals.append($0.x)
                normals.append($0.y)
                normals.append($0.z)
            }
            
            
            facesCount += facesSet.count
            
            for face in facesSet {
                faces.append(face.x + UInt32(verticesOffset))
                faces.append(face.y + UInt32(verticesOffset))
                faces.append(face.z + UInt32(verticesOffset))
            }
            
            verticesOffset = verticesCount
        }
        
        try container.encode(verticesCount, forKey: .verticesCount)
        try container.encode(Data(bytes: &vertices, count: vertices.count * MemoryLayout<Float32>.stride), forKey: .vertices)
        try container.encode(normalsCount, forKey: .normalsCount)
        try container.encode(Data(bytes: &normals, count: normals.count * MemoryLayout<Float32>.stride), forKey: .normals)
        try container.encode(facesCount, forKey: .facesCount)
        try container.encode(Data(bytes: &faces, count: faces.count * MemoryLayout<UInt32>.stride), forKey: .faces)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let verticesCount = try container.decode(Int.self, forKey: .verticesCount)
        let normalsCount = try container.decode(Int.self, forKey: .normalsCount)
        let facesCount = try container.decode(Int.self, forKey: .facesCount)
        
        let verticesData = try container.decode(Data.self, forKey: .vertices)
        let normalsData = try container.decode(Data.self, forKey: .normals)
        let facesData = try container.decode(Data.self, forKey: .faces)
        
        var verticesElements: [Float32] = []
        verticesData.withUnsafeBytes { (bytes: UnsafePointer<Float32>) in
            verticesElements = Array(UnsafeBufferPointer(start: bytes, count: verticesData.count / MemoryLayout<Float32>.size))
        }
        
        self.vertices = []
        self.vertices.append([])
        for i in 0..<verticesCount {
            self.vertices[0].append(simd_float3(x: verticesElements[i * 3], y: verticesElements[i * 3 + 1], z: verticesElements[i * 3 + 2]))
        }
        
        var normalsElements: [Float32] = []
        normalsData.withUnsafeBytes { (bytes: UnsafePointer<Float32>) in
            normalsElements = Array(UnsafeBufferPointer(start: bytes, count: normalsData.count / MemoryLayout<Float32>.size))
        }
        
        self.normals = []
        self.normals.append([])
        for i in 0..<normalsCount {
            self.normals[0].append(simd_float3(x: normalsElements[i * 3], y: normalsElements[i * 3 + 1], z: normalsElements[i * 3 + 2]))
        }
        
        var facesElements: [UInt32] = []
        facesData.withUnsafeBytes { (bytes: UnsafePointer<UInt32>) in
            facesElements = Array(UnsafeBufferPointer(start: bytes, count: facesData.count / MemoryLayout<UInt32>.size))
        }
        
        self.faces = []
        self.faces.append([])
        for i in 0..<facesCount {
            self.faces[0].append(simd_uint3(x: facesElements[i * 3], y: facesElements[i * 3 + 1], z: facesElements[i * 3 + 2]))
        }
    }
}
