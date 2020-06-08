import UIKit
import RealityKit
import ARKit

class ScanRecorderView: UIView {
    
    public var arView: ARView!
    
    public init() {
        super.init(frame: .zero)
        
        self.arView = ARView()
        self.addSubview(arView)
        self.layoutARView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutARView() {
        self.arView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            arView.topAnchor.constraint(equalTo: self.topAnchor),
            arView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
