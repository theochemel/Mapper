import Foundation
import UIKit
import SceneKit.ModelIO

class ReconstructionVisualizationView: UIView {
    
    public var sceneView: SCNView!
    
    public init() {
        super.init(frame: .zero)
        self.sceneView = SCNView()
        self.addSubview(self.sceneView)
        self.layoutSceneView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func draw(asset: MDLAsset) {
        self.sceneView.scene = SCNScene()
        
        let assetScene = SCNScene(mdlAsset: asset)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.gray
        material.isDoubleSided = true
        
       _ = assetScene.rootNode.childNodes.map {
            self.sceneView.scene?.rootNode.addChildNode($0)
            if let elementCount = $0.geometry?.elements.count {
                $0.geometry?.materials = Array(repeating: material, count: elementCount)
            }
        }
        
        self.setupSceneView()
    }
    
    private func setupSceneView() {
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.allowsCameraControl = true
    }
    
    private func layoutSceneView() {
        self.sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sceneView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.sceneView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.sceneView.topAnchor.constraint(equalTo: self.topAnchor),
            self.sceneView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
