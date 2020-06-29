import Foundation
import UIKit
import ARKit

class FloorplanVisualizationView: UIView {
    
    public var scrollView: UIScrollView!
    public var scaleView: FloorplanVisualizationScaleView!
    public var scaleViewWidthConstraint: NSLayoutConstraint!
    public var screenSpaceMapScale: CGFloat!
    private var mapView: UIView!
    private var mapLayer: CAShapeLayer!
    
    public init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        
        self.mapView = UIView()
        
        self.mapLayer = {
            let layer = CAShapeLayer()
            layer.strokeColor = UIColor.systemBlue.cgColor
            layer.lineWidth = 6.0
            layer.fillColor = .none
            return layer
        }()
        self.mapView.layer.addSublayer(self.mapLayer)
        
        self.scrollView = UIScrollView()
        self.scrollView.minimumZoomScale = 0.2
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.mapView)
        self.layoutScrollView()
        
        self.scaleView = FloorplanVisualizationScaleView()
        self.addSubview(scaleView)
        self.layoutScaleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func draw(floorplan: Floorplan) {
        let points: [simd_float2] = floorplan.points.map { $0.position }
        let xValues = points.map { $0.x }
        let yValues = points.map { $0.y }
        guard let minX = xValues.min(), let maxX = xValues.max(), let minY = yValues.min(), let maxY = yValues.max() else { return }
        
        self.mapView.frame.size = CGSize(width: self.bounds.width + 64.0, height: self.bounds.height + 64.0)
        self.mapLayer.frame.size = self.bounds.size
        self.mapLayer.frame.origin = CGPoint(x: 32.0, y: 32.0)
        
        let xScale =  self.bounds.width / CGFloat(maxX - minX)
        let yScale = self.bounds.height / CGFloat(maxY - minY)
        guard let scale = [xScale, yScale].min() else { return }
        
        self.screenSpaceMapScale = scale
        
        let path = UIBezierPath()
        
        for wall in floorplan.walls {
            
            guard wall.points.count > 1 else { continue }
            
            let firstPoint = floorplan.points.first(where: { $0.id == wall.points[0] })!
            
            let xCenteringOffset = yScale < xScale ? (self.bounds.width - scale * CGFloat(maxX - minX)) / 2.0 : 0.0
            let yCenteringOffset = xScale < yScale ? (self.bounds.height - scale * CGFloat(maxY - minY)) / 2.0 : 0.0
            
            let firstDrawPoint = CGPoint(x: CGFloat(firstPoint.position.x - minX) * scale + xCenteringOffset,
                                         y: CGFloat(firstPoint.position.y - minY) * scale + yCenteringOffset)
            path.move(to: firstDrawPoint)
            
            for i in 1..<wall.points.count {
                let point = floorplan.points.first(where: { $0.id == wall.points[i] })!
                
                let xCenteringOffset = yScale < xScale ? (self.bounds.width - scale * CGFloat(maxX - minX)) / 2.0 : 0.0
                let yCenteringOffset = xScale < yScale ? (self.bounds.height - scale * CGFloat(maxY - minY)) / 2.0 : 0.0
                
                
                let drawPoint = CGPoint(x: CGFloat(point.position.x - minX) * scale + xCenteringOffset,
                                         y: CGFloat(point.position.y - minY) * scale + yCenteringOffset)
                
                path.addLine(to: drawPoint)
            }
        }
        
        self.mapLayer.path = path.cgPath
        
        for object in floorplan.objects {
            let xCenteringOffset = yScale < xScale ? (self.bounds.width - scale * CGFloat(maxX - minX)) / 2.0 : 0.0
            let yCenteringOffset = xScale < yScale ? (self.bounds.height - scale * CGFloat(maxY - minY)) / 2.0 : 0.0
            
            let origin = CGPoint(x: CGFloat(object.position.x - (object.extent.x / 2.0) - minX) * scale + xCenteringOffset + 32.0,
                                 y: CGFloat(object.position.z - (object.extent.z / 2.0) - minY) * scale + yCenteringOffset + 32.0)
            
            var extent = CGSize(width: CGFloat(object.extent.x) * scale,
                                height: CGFloat(object.extent.z) * scale)
            
            if object.category.placementCategory() == .wallBox2D {
                if extent.width < extent.height {
                    extent.width = 8.0
                } else {
                    extent.height = 8.0
                }
            }
            
            let objectView = FloorplanVisualizationObjectView(for: object)
            objectView.frame = CGRect(origin: origin, size: extent)
            self.mapView.addSubview(objectView)
            
            print("Object: ", object.id, object.position, object.extent)
        }
        
        self.scaleViewWidthConstraint.constant = CGFloat(scale)
        self.setNeedsLayout()
        
        self.scrollView.contentSize = CGSize(width: self.mapView.frame.width, height: self.mapView.frame.height)
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
    
    private func layoutScaleView() {
        self.scaleView.translatesAutoresizingMaskIntoConstraints = false
        self.scaleViewWidthConstraint = self.scaleView.widthAnchor.constraint(equalToConstant: 0.0)
        NSLayoutConstraint.activate([
            self.scaleView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32.0),
            self.scaleViewWidthConstraint,
            self.scaleView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            self.scaleView.heightAnchor.constraint(equalToConstant: 48.0)
        ])
    }
}
