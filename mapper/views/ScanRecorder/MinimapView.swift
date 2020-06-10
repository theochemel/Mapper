import Foundation
import UIKit

class MinimapView: UIView {
    
    public var blurView: UIVisualEffectView!
    public var cameraIndicatorView: MinimapCameraIndicatorView!
    
    public init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = 18.0
        self.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .regular)
        self.blurView = UIVisualEffectView(effect: blurEffect)
        self.addSubview(blurView)
        self.layoutBlurView()
        
        self.cameraIndicatorView = MinimapCameraIndicatorView()
        self.addSubview(cameraIndicatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutBlurView() {
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.blurView.topAnchor.constraint(equalTo: self.topAnchor),
            self.blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        let origin = CGPoint(x: self.bounds.midX - 24.0, y: self.bounds.midY - 24.0)
        let size = CGSize(width: 48.0, height: 48.0)
        self.cameraIndicatorView.frame = CGRect(origin: origin, size: size)
    }
}
