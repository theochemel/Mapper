import Foundation
import ARKit
import CoreData

@objc(Wall)
public final class Wall: NSManagedObject {

    @NSManaged public var id: UUID
    @NSManaged public var points: [UUID]
    
}
