import Foundation
import UIKit
import SceneKit

class MeshVisualizationView: UIView {
    
    public var sceneView: SCNView!
    public var pointCloudToggle: UISegmentedControl!
    
    public init() {
        super.init(frame: .zero)
        self.sceneView = SCNView()
        self.addSubview(self.sceneView)
        self.setupSceneView()
        self.layoutSceneView()
        
        self.pointCloudToggle = {
            let toggle = UISegmentedControl(items: ["Mesh", "Point Cloud"])
            toggle.selectedSegmentIndex = 0
            return toggle
        }()
        self.addSubview(pointCloudToggle)
        self.layoutPointCloudToggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func draw(mesh: Mesh, shouldDrawPointCloud: Bool = false) {
        _ = self.sceneView.scene?.rootNode.childNodes(passingTest: { (node, _) in node.name == "mesh" }).map { $0.removeFromParentNode() }
        
        if shouldDrawPointCloud {
            for i in 0..<mesh.vertices.count {
                let verticesGeometrySource = SCNGeometrySource(vertices: mesh.vertices[i].map { SCNVector3($0) })
                let pointIndices = mesh.faces[i].map { [$0.x, $0.y, $0.z] }.flatMap( { $0 })
                let pointsElement = SCNGeometryElement(indices: pointIndices, primitiveType: .point)
                pointsElement.pointSize = 0.01
                pointsElement.minimumPointScreenSpaceRadius = 1.0
                pointsElement.maximumPointScreenSpaceRadius = 5.0
                
                let geometry = SCNGeometry(sources: [verticesGeometrySource], elements: [pointsElement])
                let node = SCNNode(geometry: geometry)
                node.name = "mesh"
                
                let material = SCNMaterial()
                material.isDoubleSided = true
                material.diffuse.contents = UIColor.systemBlue
                node.geometry?.firstMaterial? = material
                
                self.sceneView.scene?.rootNode.addChildNode(node)
            }
        } else {
            for i in 0..<mesh.vertices.count {

                let verticesGeometrySource = SCNGeometrySource(vertices: mesh.vertices[i].map { SCNVector3($0) })
                
                let facesIndices = mesh.faces[i].map { [$0.x, $0.y, $0.z] }.flatMap( { $0 })
                let facesGeometryElement = SCNGeometryElement(indices: facesIndices, primitiveType: .triangles)
                
                let geometry = SCNGeometry(sources: [verticesGeometrySource], elements: [facesGeometryElement])
                let node = SCNNode(geometry: geometry)
                node.name = "mesh"
                
                let material = SCNMaterial()
                material.isDoubleSided = true
                material.diffuse.contents = UIColor.systemBlue
                node.geometry?.firstMaterial? = material
                
                self.sceneView.scene?.rootNode.addChildNode(node)
            }
        }
    }
    
    private func setupSceneView() {
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.scene = SCNScene()
        self.sceneView.scene?.isPaused = false
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
    
    private func layoutPointCloudToggle() {
        self.pointCloudToggle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pointCloudToggle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.pointCloudToggle.widthAnchor.constraint(equalToConstant: 180.0),
            self.pointCloudToggle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24.0),
            self.pointCloudToggle.heightAnchor.constraint(equalToConstant: 24.0),
        ])
    }
}
