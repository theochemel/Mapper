import Foundation

public final class RawScan: NSObject, NSCoding, Codable  {
    
    var planes: [UUID: Plane]
    var objects: [UUID: Object]
    var mesh: Mesh
    
    init(planes: [UUID: Plane], objects: [UUID: Object], mesh: Mesh) {
        self.planes = planes
        self.objects = objects
        self.mesh = mesh
    }
    
    enum CodingKeys: String, CodingKey {
        case planes
        case objects
        case mesh
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        var stringKeyedPlanes: [String: Plane] = [:]
        _ = self.planes.map { stringKeyedPlanes[$0.0.uuidString] = $0.1 }
        try container.encode(stringKeyedPlanes, forKey: .planes)
        
        var stringKeyedObjects: [String: Object] = [:]
        _ = self.objects.map { stringKeyedObjects[$0.0.uuidString] = $0.1 }
        try container.encode(stringKeyedObjects, forKey: .objects)
        
        try container.encode(self.mesh, forKey: .mesh)
    }
    
    public func encode(with coder: NSCoder) {
        var stringKeyedPlanes: [String: Plane] = [:]
        _ = self.planes.map { stringKeyedPlanes[$0.0.uuidString] = $0.1 }
        coder.encode(stringKeyedPlanes, forKey: CodingKeys.planes.rawValue)
        
        var stringKeyedObjects: [String: Object] = [:]
        _ = self.objects.map { stringKeyedObjects[$0.0.uuidString] = $0.1 }
        coder.encode(stringKeyedObjects, forKey: CodingKeys.objects.rawValue)
        
        coder.encode(self.mesh, forKey: CodingKeys.mesh.rawValue)
    }
    
    convenience public init(coder: NSCoder) {
        let stringKeyedPlanes = coder.decodeObject(forKey: CodingKeys.planes.rawValue) as! [String: Plane]
        let planes = stringKeyedPlanes.map( { return (UUID(uuidString: $0.0)!, $0.1) }).reduce(into: [:]) {
            $0[$1.0] = $1.1
        }
        
        let stringKeyedObjects = coder.decodeObject(forKey: CodingKeys.objects.rawValue) as! [String: Object]
        let objects = stringKeyedObjects.map( { return (UUID(uuidString: $0.0)!, $0.1) }).reduce(into: [:]) {
            $0[$1.0] = $1.1
        }
        
        let mesh = coder.decodeObject(forKey: CodingKeys.mesh.rawValue) as! Mesh
        
        self.init(planes: planes, objects: objects, mesh: mesh)
    }
}
