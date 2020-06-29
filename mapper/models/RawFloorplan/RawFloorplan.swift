import Foundation
import CoreData

@objc(RawFloorplan)
public final class RawFloorplan: NSManagedObject {

    @NSManaged public var planes: Set<Plane>
    @NSManaged public var objects: Set<Object>
    
}
