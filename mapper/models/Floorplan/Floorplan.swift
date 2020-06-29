import Foundation
import ARKit
import CoreData

@objc(Floorplan)
public final class Floorplan: NSManagedObject {
    
    @NSManaged public var points: Set<Point>
    @NSManaged public var walls: Set<Wall>
    @NSManaged public var objects: Set<Object>

}
