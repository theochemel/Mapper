import Foundation
import ARKit

class ScanRecorder: NSObject {
    
    public var isRecording = false
    public var scanState = ScanState()
    
    weak var arViewProvider: ARViewProvider!
    weak var delegate: ScanRecorderDelegate!
    
    public func startSession() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.sceneReconstruction = .mesh
        config.environmentTexturing = .none
        config.isLightEstimationEnabled = false
        config.isAutoFocusEnabled = false
        self.arViewProvider.arView.rendersMotionBlur = false

        self.arViewProvider.arView.session.run(config, options: [])
        self.arViewProvider.arView.session.delegate = self
        self.arViewProvider.arView.delegate = self
    }
    
    public func startRecording() {
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
}

extension ScanRecorder: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = self.scanState.addPlane(from: planeAnchor)
            
            if plane.shouldBeTreatedAsWall() {
                let wallNode = WallNode(for: plane)
                wallNode.eulerAngles.x = -.pi/2

                node.addChildNode(wallNode)
            }
        }
        
        if let meshAnchor = anchor as? ARMeshAnchor {
            let mesh = meshAnchor.geometry
            let verticesSource = SCNGeometrySource(buffer: mesh.vertices.buffer, vertexFormat: mesh.vertices.format, semantic: .vertex, vertexCount: mesh.vertices.count, dataOffset: mesh.vertices.offset, dataStride: mesh.vertices.stride)
            let normalsSource = SCNGeometrySource(buffer: mesh.normals.buffer, vertexFormat: mesh.normals.format, semantic: .normal, vertexCount: mesh.normals.count, dataOffset: mesh.normals.offset, dataStride: mesh.normals.stride)
            
            let vertexCountPerFace = mesh.faces.indexCountPerPrimitive
            let vertexIndicesPointer = mesh.faces.buffer.contents()
            var vertexIndices = [UInt32]()
            vertexIndices.reserveCapacity(vertexCountPerFace)
            for vertexOffset in 0..<mesh.faces.count * mesh.faces.indexCountPerPrimitive {
                let vertexIndexPointer = vertexIndicesPointer.advanced(by: vertexOffset * MemoryLayout<UInt32>.size)
                vertexIndices.append(vertexIndexPointer.assumingMemoryBound(to: UInt32.self).pointee)
            }

            let facesElement = SCNGeometryElement(indices: vertexIndices, primitiveType: .triangles)

            let occlusionNode = SCNNode(geometry: SCNGeometry(sources: [verticesSource, normalsSource], elements: [facesElement]))
            occlusionNode.name = "occlusion"
            occlusionNode.geometry?.firstMaterial?.isDoubleSided = true
            occlusionNode.geometry?.firstMaterial?.colorBufferWriteMask = []
            occlusionNode.geometry?.firstMaterial?.writesToDepthBuffer = true
            occlusionNode.geometry?.firstMaterial?.readsFromDepthBuffer = true
            node.addChildNode(occlusionNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = self.scanState.updatePlane(from: planeAnchor)
            
            if plane.shouldBeTreatedAsWall() {
                guard let wallNode = node.childNodes.first(where: { $0 is WallNode }) as? WallNode else { return }
                wallNode.update(from: plane)
            }
        }
        if let meshAnchor = anchor as? ARMeshAnchor {
            let mesh = meshAnchor.geometry
            let verticesSource = SCNGeometrySource(buffer: mesh.vertices.buffer, vertexFormat: mesh.vertices.format, semantic: .vertex, vertexCount: mesh.vertices.count, dataOffset: mesh.vertices.offset, dataStride: mesh.vertices.stride)
            let normalsSource = SCNGeometrySource(buffer: mesh.normals.buffer, vertexFormat: mesh.normals.format, semantic: .normal, vertexCount: mesh.normals.count, dataOffset: mesh.normals.offset, dataStride: mesh.normals.stride)
            
            let vertexCountPerFace = mesh.faces.indexCountPerPrimitive
            let vertexIndicesPointer = mesh.faces.buffer.contents()
            var vertexIndices = [UInt32]()
            vertexIndices.reserveCapacity(vertexCountPerFace)
            for vertexOffset in 0..<mesh.faces.count * mesh.faces.indexCountPerPrimitive {
                let vertexIndexPointer = vertexIndicesPointer.advanced(by: vertexOffset * MemoryLayout<UInt32>.size)
                vertexIndices.append(vertexIndexPointer.assumingMemoryBound(to: UInt32.self).pointee)
            }

            let facesElement = SCNGeometryElement(indices: vertexIndices, primitiveType: .triangles)
            
            if let occlusionNode = node.childNode(withName: "occlusion", recursively: true) {
                occlusionNode.geometry = SCNGeometry(sources: [verticesSource, normalsSource], elements: [facesElement])
                occlusionNode.geometry?.firstMaterial?.isDoubleSided = true
                occlusionNode.geometry?.firstMaterial?.colorBufferWriteMask = []
                occlusionNode.geometry?.firstMaterial?.writesToDepthBuffer = true
                occlusionNode.geometry?.firstMaterial?.readsFromDepthBuffer = true
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            self.scanState.removePlane(from: planeAnchor)
        }
    }
    
}
