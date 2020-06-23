import Foundation
import UIKit

extension ReconstructionVisualizationViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        let ifcTempPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("ifc")
        do {
            try self.reconstruction.ifcData.write(to: ifcTempPath, atomically: true, encoding: .utf8)

            let provider = NSItemProvider(contentsOf: ifcTempPath)!
            
//            provider.registerDataRepresentation(forTypeIdentifier: "obj", visibility: .all) { completionHandler -> Progress? in
//
//                let progress = Progress(totalUnitCount: 100)
//                progress.completedUnitCount = 100
//
//                completionHandler(self.reconstruction.objData.data(using: .utf8), nil)
//
//                return progress
//            }

//            provider.registerFileRepresentation(forTypeIdentifier: "ifc", fileOptions: [], visibility: .all) { (completionHandler: @escaping (URL?, Bool, Error?) -> Void) -> Progress? in
//
//                let progress = Progress(totalUnitCount: 100)
//                progress.completedUnitCount = 100
//
//                completionHandler(ifcTempPath, true, nil)
//
//                return progress
//            }
            
            
            let item = UIDragItem(itemProvider: provider)
            return [item]
            
        } catch(let error) {
            print("Error writing IFC data: ", error)
            return []
        }
    }
}
