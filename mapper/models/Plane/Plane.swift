import Foundation
import ARKit
import CoreData

@objc(Plane)
public final class Plane: NSManagedObject {
    
    @NSManaged public var id: UUID
    @NSManaged private var classificationString: String
    @NSManaged private var alignmentString: String
    @NSManaged public var positionData: Data
    @NSManaged public var rotationData: Data
    @NSManaged public var extentData: Data
    
    public var position: simd_float3 {
        get {
            return self.positionData.withUnsafeBytes { $0.load(as: simd_float3.self) }
        }
        
        set(newValue) {
            self.positionData = withUnsafeBytes(of: newValue) { Data($0) }
        }
    }
    
    public var rotation: simd_quatf {
        get {
            return self.rotationData.withUnsafeBytes { $0.load(as: simd_quatf.self) }
        }
        
        set(newValue) {
            self.rotationData = withUnsafeBytes(of: newValue) { Data($0) }
        }
    }
    
    public var extent: simd_float3 {
        get {
            return self.extentData.withUnsafeBytes { $0.load(as: simd_float3.self) }
        }
        
        set(newValue) {
            self.extentData = withUnsafeBytes(of: newValue) { Data($0) }
        }
    }
    
    public var classification: Classification {
        get {
            return Classification(rawValue: self.classificationString)!
        }
        set(newValue) {
            self.classificationString = newValue.rawValue
        }
    }
    
    public var alignment: Alignment {
        get {
            return Alignment(rawValue: self.alignmentString)!
        }
        set(newValue) {
            self.alignmentString = newValue.rawValue
        }
    }
    
    public func update(from anchor: ARPlaneAnchor) {
        self.id = anchor.identifier
        self.classification = Classification(from: anchor.classification)
        self.alignment = Alignment(from: anchor.alignment)

        self.rotation = simd_quatf(anchor.transform)
        self.position = simd_float3(anchor.transform[3][0], anchor.transform[3][1], anchor.transform[3][2]) + self.rotation.act(anchor.center)
        self.extent = anchor.extent
    }
    
    public func shouldBeTreatedAsWall() -> Bool {
        return self.alignment == .vertical
    }
}
