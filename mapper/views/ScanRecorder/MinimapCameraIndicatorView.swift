import Foundation
import UIKit

class MinimapCameraIndicatorView: UIView {
    
    private var directionLayer: CAShapeLayer!
    private var circleLayer: CAShapeLayer!

    public init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        
        self.directionLayer = {
            let layer = CAShapeLayer()
            
            let arcPath = UIBezierPath()
            arcPath.move(to: self.center)
            arcPath.addArc(withCenter: self.center, radius: 24.0, startAngle: CGFloat.pi  * 13.0 / 4.0, endAngle: CGFloat.pi * 15.0 / 4.0, clockwise: true)
            layer.path = arcPath.cgPath
            layer.fillColor = UIColor.systemBlue.withAlphaComponent(0.4).cgColor
            return layer
        }()
        self.layer.addSublayer(self.directionLayer)
        
        self.circleLayer = {
            let layer = CAShapeLayer()
            
            let circlePath = UIBezierPath(arcCenter: self.center, radius: 6.0, startAngle: 0.0, endAngle: CGFloat.pi * 2.0, clockwise: true)
            layer.path = circlePath.cgPath
            
            layer.fillColor = UIColor.systemBlue.cgColor
            layer.strokeColor = UIColor.white.cgColor
            layer.lineWidth = 2.0
            return layer
        }()
        self.layer.addSublayer(self.circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.circleLayer.frame = CGRect(x: self.bounds.midX, y: self.bounds.midY, width: 12.0, height: 12.0)
        self.directionLayer.frame = CGRect(x: self.bounds.midX, y: self.bounds.midY, width: 48.0, height: 48.0)
        self.layer.cornerRadius = self.bounds.height / 2.0
    }
}
