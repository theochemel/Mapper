import Foundation
import ARKit

class ScanRecorder: NSObject {
    
    public var isRecording = false
    public var scanState = ScanState()
    public var objectPlacementManager: ObjectPlacementManager? = nil
    
    weak var arViewProvider: ARViewProvider!
    weak var delegate: ScanRecorderDelegate!
    
    public func startSession() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.sceneReconstruction = .mesh
        config.environmentTexturing = .none
        config.isLightEstimationEnabled = true
        config.isAutoFocusEnabled = false
        self.arViewProvider.arView.rendersMotionBlur = false
        self.arViewProvider.arView.automaticallyUpdatesLighting = true
        self.arViewProvider.arView.autoenablesDefaultLighting = false
        self.arViewProvider.arView.session.run(config, options: [])
        self.arViewProvider.arView.session.delegate = self
        self.arViewProvider.arView.delegate = self
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        self.arViewProvider.arView.pointOfView?.addChildNode(lightNode)
    }
    
    public func startRecording() {
        self.isRecording = true
    }
    
    public func stopRecording() {
        self.isRecording = false
        
        guard let currentFrame = self.arViewProvider.arView.session.currentFrame else { fatalError("Tried to stop recording, but couldn't get the latest frame.") }
        
        let rawScan = RawScan(planes: scanState.planes, objects: scanState.objects, mesh: Mesh(from: currentFrame.anchors.filter { $0 is ARMeshAnchor } as! [ARMeshAnchor]))
        
        self.delegate.didFinishScan(rawScan)
    }
    
    public func startPlacement(for category: Object.Category) {
        switch category.placementCategory() {
        case .wallBox2D: self.objectPlacementManager = WallBox2DPlacementManager(for: category)
        case .floorBox2D: self.objectPlacementManager = FloorBox2DPlacementManager(for: category)
        }
        self.objectPlacementManager?.arViewProvider = self.arViewProvider
        self.objectPlacementManager?.delegate = self
        self.objectPlacementManager?.start()
    }
    
    public func stopPlacement() {
        self.objectPlacementManager?.stop()
        self.objectPlacementManager = nil
    }
}
