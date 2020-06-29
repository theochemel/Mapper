import Foundation
import CoreData

@objc(Scan)
public final class Scan: NSManagedObject {
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var address: String
    @NSManaged public var floor: String
    
    @NSManaged public var rawFloorplan: RawFloorplan?
    @NSManaged public var floorplan: Floorplan?
    @NSManaged public var reconstruction: Reconstruction?
    @NSManaged public var pointCloud: PointCloud?
    
    public var isCompleted: Bool {
        return self.rawFloorplan != nil
    }
    
    public var isFloorplanCompleted: Bool {
        return self.floorplan != nil
    }
    
    public var isReconstructionCompleted: Bool {
        return self.reconstruction != nil
    }
    
    public var isPointCloudCompleted: Bool {
        return self.pointCloud != nil
    }
}
