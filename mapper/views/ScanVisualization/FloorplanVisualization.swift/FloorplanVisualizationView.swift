import Foundation
import UIKit
import ARKit

class FloorplanVisualizationView: UIView {
    
    public var scrollView: UIScrollView!
    private var wallsView: UIView!
    private var wallsLayer: CAShapeLayer!
    
    public init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        
        self.wallsView = UIView()
        
        self.wallsLayer = {
            let layer = CAShapeLayer()
            layer.strokeColor = UIColor.systemBlue.cgColor
            layer.lineWidth = 6.0
            layer.fillColor = .none
            return layer
        }()
        self.wallsView.layer.addSublayer(self.wallsLayer)
        
        self.scrollView = UIScrollView()
        self.scrollView.minimumZoomScale = 0.2
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.wallsView)
        self.layoutScrollView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func draw(floorplan: Floorplan) {
        let points: [simd_float2] = floorplan.walls.map { [$0.start, $0.end] }.flatMap { $0 }.map { $0.position }
        let xValues = points.map { $0.x }
        let yValues = points.map { $0.y }
        guard let minX = xValues.min(), let maxX = xValues.max(), let minY = yValues.min(), let maxY = yValues.max() else { return }
        
        self.wallsView.frame.size = CGSize(width: self.bounds.width + 64.0, height: self.bounds.height + 64.0)
        self.wallsLayer.frame.size = self.bounds.size
        self.wallsLayer.frame.origin = CGPoint(x: 32.0, y: 32.0)
        
        let xScale =  self.bounds.width / CGFloat(maxX - minX)
        let yScale = self.bounds.height / CGFloat(maxY - minY)
        guard let scale = [xScale, yScale].min() else { return }
        
        let path = UIBezierPath()
        
        for wall in floorplan.walls {
            let xCenteringOffset = yScale < xScale ? (self.bounds.width - scale * CGFloat(maxX - minX)) / 2.0 : 0.0
            let yCenteringOffset = xScale < yScale ? (self.bounds.height - scale * CGFloat(maxY - minY)) / 2.0 : 0.0
            
            
            let startPoint = CGPoint(x: CGFloat(wall.start.position.x - minX) * scale + xCenteringOffset,
                                     y: CGFloat(wall.start.position.y - minY) * scale + yCenteringOffset)
            let endPoint = CGPoint(x: CGFloat(wall.end.position.x - minX) * scale + xCenteringOffset,
                                   y: CGFloat(wall.end.position.y - minY) * scale + yCenteringOffset)
            
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        
        self.wallsLayer.path = path.cgPath
        
        self.scrollView.contentSize = CGSize(width: self.wallsView.frame.width, height: self.wallsView.frame.height)
        self.scrollView.zoomScale = 0.9
    }
    
    private func layoutScrollView() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
