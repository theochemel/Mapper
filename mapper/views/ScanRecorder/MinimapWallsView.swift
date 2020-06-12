import Foundation
import UIKit
import ARKit

class MinimapWallsView: UIView {
    
    private var wallsLayer: CAShapeLayer!
    private var scale: CGFloat!
    
    public init(scale: CGFloat) {
        super.init(frame: .zero)
        
        self.scale = scale
        
        self.backgroundColor = .clear
        
        self.wallsLayer = {
            let layer = CAShapeLayer()
            
            layer.strokeColor = UIColor.systemBlue.cgColor
            layer.fillColor = .none
            
            return layer
        }()
        
        self.layer.addSublayer(self.wallsLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.wallsLayer.frame = self.bounds
    }
    
    public func drawWalls(from planes: [Plane], cameraPosition: simd_float3) {
                
        let path = UIBezierPath()
        
        for plane in planes.filter({ $0.shouldBeTreatedAsWall() }) {
            let translation = simd_float3(plane.transform[3][0], plane.transform[3][1], plane.transform[3][2])
            let adjustedPosition = translation + plane.rotation.act(plane.position)
            
            let origin = self.center
                        
            let yaw = -asin(2.0 * (plane.rotation.real * plane.rotation.imag.y - plane.rotation.imag.z * plane.rotation.imag.x))
            let roundedYaw = (Float.pi / 2.0) * round(yaw / (Float.pi / 2.0))
            
            let rotatedExtent = simd_float2(plane.extent.x * cos(roundedYaw), plane.extent.x * sin(roundedYaw))
            
            let startPosition = simd_float2(adjustedPosition.x, adjustedPosition.z) - 0.5 * rotatedExtent
            let endPosition = simd_float2(adjustedPosition.x, adjustedPosition.z) + 0.5 * rotatedExtent
            
            let startDrawPoint = CGPoint(x: CGFloat(startPosition.x - cameraPosition.x) * self.scale + origin.x, y: CGFloat(startPosition.y - cameraPosition.z) * self.scale + origin.y)
            let endDrawPoint = CGPoint(x: CGFloat(endPosition.x - cameraPosition.x) * self.scale + origin.x, y: CGFloat(endPosition.y - cameraPosition.z) * self.scale + origin.y)
            
            path.move(to: startDrawPoint)
            path.addLine(to: endDrawPoint)
        }
        
        self.wallsLayer.path = path.cgPath
    }
}
