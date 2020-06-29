import Foundation
import ARKit
import CoreData

@objc(MapperObject)
public final class Object: NSManagedObject {
    
    @NSManaged public var id: UUID
    @NSManaged private var categoryString: String
    @NSManaged public var positionData: Data
    @NSManaged public var extentData: Data
    
    public var category: Category {
        get {
            return Category(rawValue: self.categoryString)!
        }
        
        set(newValue) {
            self.categoryString = newValue.rawValue
        }
    }
    
    public var position: simd_float3 {
        get {
            return self.positionData.withUnsafeBytes { $0.load(as: simd_float3.self) }
        }
        set(newValue) {
            self.positionData = withUnsafeBytes(of: newValue) { Data($0) }
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
}
