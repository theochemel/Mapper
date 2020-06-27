import Foundation
import ARKit

extension ScanRecorder: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard self.isRecording else { return }
        
        self.pointCloudManager?.update(from: frame)
        self.scanState.update(from: frame)
        self.delegate.didUpdateScanState(self.scanState)
        
        let hitTestResults = self.arViewProvider.arView.hitTest(self.arViewProvider.arView.center, types: [.existingPlaneUsingExtent, .featurePoint])
        
        if let result = hitTestResults.first {
            if let plane = result.anchor as? ARPlaneAnchor {
                self.objectPlacementManager?.rotateCursor(to: SCNQuaternion(simd_quatf(plane.transform).vector), distance: result.distance)
            } else {
                self.objectPlacementManager?.rotateCursorTowardsCamera(distance: result.distance)
            }
        }
    }
}
