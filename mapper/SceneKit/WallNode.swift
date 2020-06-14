import Foundation
import SceneKit

class WallNode: SCNNode {
    
    static let particleSystem: SCNParticleSystem = {
        let particleSystem = SCNParticleSystem()
        particleSystem.particleColor = UIColor.systemBlue
        particleSystem.particleColorVariation = SCNVector4(0.0, 1.0, 1.0, 1.1)
        particleSystem.particleSize = 0.005
        particleSystem.emittingDirection = SCNVector3(0.0, 0.0, 0.2)
        particleSystem.spreadingAngle = 45.0
        particleSystem.particleAngle = 45.0
        particleSystem.particleAngleVariation = 180.0
        particleSystem.particleVelocity = 0.1
        particleSystem.particleVelocityVariation = 0.2
        return particleSystem
    }()
    
    init(for plane: Plane) {
        super.init()
        
        let particleSystem = WallNode.particleSystem
        particleSystem.emitterShape = SCNPlane(width: CGFloat(plane.extent.x), height: CGFloat(plane.extent.y))
        particleSystem.birthRate = CGFloat(plane.extent.x * plane.extent.y * 40.0)
        
        self.addParticleSystem(particleSystem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(from plane: Plane) {
        guard let particleSystem = self.particleSystems?.first else { return }
        particleSystem.emitterShape = SCNPlane(width: CGFloat(plane.extent.x), height: CGFloat(plane.extent.z))
        particleSystem.birthRate = CGFloat(plane.extent.x * plane.extent.z * 60.0)
    }
}
