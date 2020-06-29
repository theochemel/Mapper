import Foundation
import SceneKit
import ModelIO
import CoreData

@objc(Reconstruction)
public final class Reconstruction: NSManagedObject {
    
    @NSManaged public var ifcFilePath: URL
    @NSManaged public var objFilePath: URL
    @NSManaged public var objMtlFilePath: URL
    
}
