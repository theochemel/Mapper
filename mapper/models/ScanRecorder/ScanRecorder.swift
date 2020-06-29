import Foundation
import ARKit
import CoreData

class ScanRecorder: NSObject {
    
    public var context: NSManagedObjectContext!
        
    public var isRecording = false

    public var scanState: ScanState!
    public var objectPlacementManager: ObjectPlacementManager?
    public var pointCloudManager: PointCloudManager?
    
    weak var arViewProvider: ARViewProvider!
    weak var delegate: ScanRecorderDelegate!
    
    public var wallNode: WallNode?
  
    private var orientation: UIInterfaceOrientation!
    private var viewportSize: CGSize!
    
    public init(context: NSManagedObjectContext, orientation: UIInterfaceOrientation, viewportSize: CGSize) {
        self.context = context
        self.scanState = ScanState(context: context)
        self.orientation = orientation
        self.viewportSize = viewportSize
    }
  
    public func startSession() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.sceneReconstruction = .mesh
        config.environmentTexturing = .none
        config.isLightEstimationEnabled = true
        config.isAutoFocusEnabled = false
        config.frameSemantics = [.sceneDepth]
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
        self.pointCloudManager = PointCloudManager(context: context)
        self.pointCloudManager?.orientation = orientation
        self.pointCloudManager?.viewportSize = viewportSize
        
        self.isRecording = true
        
        self.wallNode = WallNode()
        self.arViewProvider.arView.scene.rootNode.addChildNode(self.wallNode!)
    }
    
    public func stopRecording() {
        self.isRecording = false
        
        let rawFloorplan = RawFloorplan(context: self.context)
        rawFloorplan.planes = Set(self.scanState.planes.values)
        rawFloorplan.objects = Set(self.scanState.objects.values)
        self.delegate.didFinishScanning(rawFloorplan: rawFloorplan, pointCloud: self.pointCloudManager?.pointCloud)
    }
    
    public func startPlacement(for category: Object.Category) {
        self.objectPlacementManager?.stop()
        switch category.placementCategory() {
        case .wallBox2D: self.objectPlacementManager = WallBox2DPlacementManager(for: category, context: self.context)
        case .floorBox2D: self.objectPlacementManager = FloorBox2DPlacementManager(for: category, context: self.context)
        }
        self.objectPlacementManager?.arViewProvider = self.arViewProvider
        self.objectPlacementManager?.delegate = self
        self.objectPlacementManager?.start()
    }
    
    public func stopPlacement() {
        self.objectPlacementManager?.stop()
        self.objectPlacementManager = nil
    }
    
    public func orientationDidChange(_ orientation: UIInterfaceOrientation) {
        self.orientation = orientation
        self.pointCloudManager?.orientation = orientation
    }
    
    public func viewportSizeDidChange(_ size: CGSize) {
        self.viewportSize = size
        self.pointCloudManager?.viewportSize = size
    }
}
