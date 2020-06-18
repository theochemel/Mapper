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
                print("Error decoding rawScanData: ", error)
                return nil
            }
        }
        
        set(newValue) {
            guard let rawScan = newValue else { self.rawScanData = nil; return }
            do {
                self.rawScanData = try JSONEncoder().encode(rawScan) as NSData
            } catch(let error) {
                print("Error encoding rawScan: ", error)
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
                print("Error decoding cleanedScanData: ", error)
                return nil
            }
        }
        
        set(newValue) {
            guard let cleanedScan = newValue else { self.cleanedScanData = nil; return }
            do {
                self.cleanedScanData = try JSONEncoder().encode(cleanedScan) as NSData
            } catch(let error) {
                print("Error encoding cleanedScan: ", error)
                self.cleanedScanData = nil
            }
        }

    }
    
    public func didFinishRawScan(_ rawScan: RawScan, backendURL: String) {
        self.rawScan = rawScan
        self.isScanCompleted = true
                
        guard let url = URL(string: backendURL) else { return }
        
        do {
            let rawScanData = try JSONEncoder().encode(rawScan)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = rawScanData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Network error: ", error as Any)
                    return
                    // show error UI
                }
                
                guard let data = data else { print("No data!"); return }

                print(data)
                
                do {
                    self.cleanedScan = try JSONDecoder().decode(CleanedScan.self, from: data)
                    try DispatchQueue.main.sync {
                        try self.managedObjectContext?.save()
                    }
                } catch(let error) {
                    print("Error decoding or saving: ", error)
                }
            }
            
            task.resume()
            
        } catch(let error) {
            print("Error encoding: ", error)
        }
    }
}
