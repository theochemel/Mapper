import Foundation
import ARKit

extension ScanRecorder: ObjectPlacementManagerDelegate {
    func didAddObject(_ object: Object) {
        self.scanState.addObject(object)
        self.objectPlacementManager?.stop()
        self.objectPlacementManager = nil
    }
}
