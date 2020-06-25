import Foundation
import SceneKit
import ARKit

class WallNode: SCNNode {
    
    var planeGeometries: [UUID: (SCNGeometrySource, SCNGeometryElement)] = [:]
    
    static let particleSystem: SCNParticleSystem = {
        let particleSystem = SCNParticleSystem()
        particleSystem.particleColor = UIColor.systemBlue
        particleSystem.particleColorVariation = SCNVector4(0.0, 1.0, 1.0, 1.1)
        particleSystem.particleSize = 0.005
        particleSystem.particleVelocity = 0.1
        particleSystem.particleVelocityVariation = 0.2
        return particleSystem
    }()
    
    override init() {
        super.init()
        
        let particleSystem = WallNode.particleSystem
        particleSystem.birthRate = 2000
        self.addParticleSystem(particleSystem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addPlane(_ planeAnchor: ARPlaneAnchor) {
        let newGeometry = self.geometry(for: planeAnchor)
        
        self.planeGeometries[planeAnchor.identifier] = (newGeometry.sources.first!, newGeometry.elements.first!)
        
        self.updateEmitterShape()
    }
    
    public func updatePlane(_ planeAnchor: ARPlaneAnchor) {
        let newGeometry = self.geometry(for: planeAnchor)
        
        self.planeGeometries[planeAnchor.identifier] = (newGeometry.sources.first!, newGeometry.elements.first!)
        
        self.updateEmitterShape()
    }
    
    public func removePlane(withID id: UUID) {
        self.planeGeometries[id] = nil
        
        self.updateEmitterShape()
    }
    
    private func geometry(for planeAnchor: ARPlaneAnchor) -> SCNGeometry {
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let source = geometry.sources.first!
        var data = Data(repeating: 0, count: 12 * (source.data.count - source.dataOffset) / source.dataStride)
        
        for i in stride(from: source.dataOffset, to: source.data.count / source.dataStride, by: 1) {
            
            let sourceIndex = i * source.dataStride
            let x = source.data[sourceIndex...sourceIndex+3].withUnsafeBytes { $0.load(as: Float.self) }
            let y = source.data[sourceIndex+4...sourceIndex+7].withUnsafeBytes { $0.load(as: Float.self) }
            let z = source.data[sourceIndex+8...sourceIndex+11].withUnsafeBytes { $0.load(as: Float.self) }
            
            var position = simd_float3(x, y, z)
            position = simd_quatf(angle: .pi / 2, axis: simd_float3(1.0, 0.0, 0.0)).act(position)
            
            let rotation = simd_quatf(planeAnchor.transform)
            
            position = rotation.act(position)
            
            let translation = simd_float3(planeAnchor.transform[3][0], planeAnchor.transform[3][1], planeAnchor.transform[3][2]) + rotation.act(planeAnchor.center)
            
            position += translation
            
            let destinationIndex = i * 12
            data.replaceSubrange(destinationIndex...destinationIndex+3, with: withUnsafeBytes(of: position.x) { Data($0) })
            data.replaceSubrange(destinationIndex+4...destinationIndex+7, with: withUnsafeBytes(of: position.y) { Data($0) })
            data.replaceSubrange(destinationIndex+8...destinationIndex+11, with: withUnsafeBytes(of: position.z) { Data($0) })
        }
        
        let newSource = SCNGeometrySource(data: data,
                                          semantic: .vertex,
                                          vectorCount: source.vectorCount,
                                          usesFloatComponents: true,
                                          componentsPerVector: 3,
                                          bytesPerComponent: 4,
                                          dataOffset: 0,
                                          dataStride: 12)
        
        return SCNGeometry(sources: [newSource], elements: [geometry.elements.first!])
    }
    
    private func updateEmitterShape() {
        let planeGeometries: [(SCNGeometrySource, SCNGeometryElement)] = Array(self.planeGeometries.values)
        
        var combinedPlaneGeometrySourcesData = Data()
        
        var planeGeometryElements: [SCNGeometryElement] = []
        
        var offset: UInt16 = 0
        for planeGeometry in planeGeometries {
            combinedPlaneGeometrySourcesData.append(planeGeometry.0.data)
            
            var planeGeometryElementData = Data()
            for i in stride(from: 0, to: planeGeometry.1.data.count, by: 2) {
                let index: UInt16 = planeGeometry.1.data[i...i+1].withUnsafeBytes { $0.load(as: UInt16.self) } + offset
                planeGeometryElementData.append(withUnsafeBytes(of: index) { Data($0) })
            }
            
            let planeGeometryElement = SCNGeometryElement(data: planeGeometryElementData,
                                                          primitiveType: .triangles,
                                                          primitiveCount: planeGeometryElementData.count / 6,
                                                          bytesPerIndex: 2)
            planeGeometryElements.append(planeGeometryElement)
            
            offset = UInt16(combinedPlaneGeometrySourcesData.count / 12)
        }
        
        let combinedPlaneGeometrySource = SCNGeometrySource(data: combinedPlaneGeometrySourcesData,
                                                            semantic: .vertex,
                                                            vectorCount: combinedPlaneGeometrySourcesData.count / 12,
                                                            usesFloatComponents: true,
                                                            componentsPerVector: 3,
                                                            bytesPerComponent: 4,
                                                            dataOffset: 0,
                                                            dataStride: 12)
        

        let combinedPlaneGeometry = SCNGeometry(sources: [combinedPlaneGeometrySource], elements: planeGeometryElements)
        
        self.particleSystems?.first?.emitterShape = combinedPlaneGeometry
    }
}
