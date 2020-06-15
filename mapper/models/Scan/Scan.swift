import Foundation
import CoreData

@objc(Scan)
public class Scan: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var address: String
    @NSManaged public var floor: String
    @NSManaged public var isScanCompleted: Bool
    @NSManaged public var rawScan: RawScan?
    @NSManaged public var cleanedScan: CleanedScan?
    
    public func didFinishRawScan(_ rawScan: RawScan) {
        self.rawScan = rawScan
        self.isScanCompleted = true
        
        self.cleanedScan = CleanedScan(mesh: rawScan.mesh)
    }
}
