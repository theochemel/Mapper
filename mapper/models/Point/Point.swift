import Foundation
import ARKit
import CoreData

@objc(Point)
public final class Point: NSManagedObject {
    
    @NSManaged public var id: UUID
    @NSManaged public var position: simd_float2
}
