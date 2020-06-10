import Foundation
import ARKit
import RealityKit

class ScanRecorder: NSObject {
    
    public var isRecording = false
    public var scanState = ScanState()
    
    weak var arViewProvider: ARViewProvider!
    weak var delegate: ScanRecorderDelegate!
    
    public func startSession() {
        self.arViewProvider.arView.environment.sceneUnderstanding.options.insert(.occlusion)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.sceneReconstruction = .mesh

        self.arViewProvider.arView.session.run(config, options: [])
        self.arViewProvider.arView.session.delegate = self
    }
    
    public func startRecording() {
        self.startSession()
        self.isRecording = true
        print("start recording")
    }
    
    public func stopRecording() {
        self.isRecording = false
        print("stop recording")
    }
}

extension ScanRecorder: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard self.isRecording else { return }
        self.scanState.update(from: frame)
        self.delegate.didUpdateScanState(self.scanState)
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard self.isRecording else { return }
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let plane = self.scanState.addPlane(from: planeAnchor)
                
                if plane.classification == .wall {
                    let planeAnchorEntity = AnchorEntity(anchor: planeAnchor)
                    planeAnchorEntity.name = plane.id.uuidString
                    let wallEntity = WallEntity(plane: plane)
                    
                    if let currentFrame = session.currentFrame {
                        let cameraPosition = simd_float3(currentFrame.camera.transform.columns.3[0],
                                                         currentFrame.camera.transform.columns.3[1],
                                                         currentFrame.camera.transform.columns.3[2])
                        wallEntity.transform.translation = 0.1 * simd_normalize(cameraPosition - plane.position)
                    }
                    wallEntity.transform.translation = simd_float3(0.0, 0.0, 0.1)
                    
                    planeAnchorEntity.addChild(wallEntity)
                    self.arViewProvider.arView.scene.addAnchor(planeAnchorEntity)
                }
            }
        }
        
        self.delegate.didUpdateScanState(self.scanState)
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard self.isRecording else { return }
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let plane = self.scanState.updatePlane(from: planeAnchor)
                
                if plane.classification == .wall {
                    let planeAnchorEntity = self.arViewProvider.arView.scene.findEntity(named: plane.id.uuidString)
                    guard let wallEntity = planeAnchorEntity?.children.first(where: { $0 is WallEntity }) as? WallEntity else { continue }
                    wallEntity.update(from: plane)
                    
                    if let currentFrame = session.currentFrame {
                        let cameraPosition = simd_float3(currentFrame.camera.transform.columns.3[0],
                                                         currentFrame.camera.transform.columns.3[1],
                                                         currentFrame.camera.transform.columns.3[2])
                        wallEntity.transform.translation = 0.1 * simd_normalize(cameraPosition - plane.position)
                    }
                }
            }
        }
        self.delegate.didUpdateScanState(self.scanState)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard self.isRecording else { return}
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.scanState.removePlane(from: planeAnchor)
            }
        }
        self.delegate.didUpdateScanState(self.scanState)
    }
}
