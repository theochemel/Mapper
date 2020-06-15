import Foundation
import CoreData

@objc(Scan)
public class Scan: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var address: String
    @NSManaged public var floor: String
    @NSManaged public var isScanCompleted: Bool
    @NSManaged public var rawScanData: NSData?
    @NSManaged public var cleanedScanData: NSData?
    
    public var rawScan: RawScan? {
        get {
            guard let rawScanData = self.rawScanData else { return nil }
            do {
                return try JSONDecoder().decode(RawScan.self, from: rawScanData as Data)
            } catch(let error) {
                print(error.localizedDescription)
                return nil
            }
        }
        
        set(newValue) {
            guard let rawScan = newValue else { self.rawScanData = nil; return }
            do {
                self.rawScanData = try JSONEncoder().encode(rawScan) as NSData
            } catch(let error) {
                print(error.localizedDescription)
                self.rawScanData = nil
            }
        }
    }
    
    public var cleanedScan: CleanedScan? {
        get {
            guard let cleanedScanData = self.cleanedScanData else { return nil }
            do {
                return try JSONDecoder().decode(CleanedScan.self, from: cleanedScanData as Data)
            } catch(let error) {
                print(error.localizedDescription)
                return nil
            }
        }
        
        set(newValue) {
            guard let cleanedScan = newValue else { self.cleanedScanData = nil; return }
            do {
                self.cleanedScanData = try JSONEncoder().encode(cleanedScan) as NSData
            } catch(let error) {
                print(error.localizedDescription)
                self.cleanedScanData = nil
            }
        }

    }
    
    public func didFinishRawScan(_ rawScan: RawScan) {
        self.rawScan = rawScan
        self.isScanCompleted = true
        
        self.cleanedScan = CleanedScan(mesh: rawScan.mesh)
    }
}
