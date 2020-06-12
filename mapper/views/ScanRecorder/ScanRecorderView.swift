import Foundation
import UIKit
import RealityKit
import ARKit

class ScanRecorderView: UIView, ARViewProvider {
    
    public var arView: ARSCNView!
    public var recordButton: UIButton!
    public var coachingView: CoachingView!
    public var objectSelectorView: ObjectSelectorView!
    public var minimapView: MinimapView!
    
    public init() {
        super.init(frame: .zero)
        
        self.arView = ARSCNView()
        self.addSubview(arView)
        self.layoutARView()
        
        self.recordButton = {
            let button = UIButton()
            button.setTitle("RECORD", for: .normal)
            button.titleLabel?.font = .monospacedSystemFont(ofSize: button.titleLabel?.font.pointSize ?? 12.0, weight: .regular)
            button.setTitleColor(.systemRed, for: .normal)
            button.layer.cornerRadius = 18.0
            button.clipsToBounds = true
            
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
            
            blurView.frame = button.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView.isUserInteractionEnabled = false
            
            button.insertSubview(blurView, at: 0)
            
            return button
        }()
        self.addSubview(recordButton)
        self.layoutRecordButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCoachingView(_ view: CoachingView) {
        self.coachingView?.removeFromSuperview()
        self.coachingView = view
        self.addSubview(self.coachingView)
        self.layoutCoachingView()
    }
    
    public func setObjectSelectorView(_ view: ObjectSelectorView) {
        self.objectSelectorView?.removeFromSuperview()
        self.objectSelectorView = view
        self.addSubview(self.objectSelectorView)
        self.layoutObjectSelectorView()
    }
    
    public func setMinimapView(_ view: MinimapView) {
        self.minimapView?.removeFromSuperview()
        self.minimapView = view
        self.addSubview(self.minimapView)
        self.layoutMinimapView()
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
    
    private func layoutRecordButton() {
        self.recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 128.0),
            recordButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32.0),
            recordButton.heightAnchor.constraint(equalToConstant: 36.0)
        ])
    }
    
    private func layoutCoachingView() {
        self.coachingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coachingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.coachingView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0.0)
        ])
    }
    
    private func layoutObjectSelectorView() {
        self.objectSelectorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.objectSelectorView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32.0),
            self.objectSelectorView.widthAnchor.constraint(equalToConstant: 160.0),
            self.objectSelectorView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32.0),
        ])
    }
    
    private func layoutMinimapView() {
        self.minimapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.minimapView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32.0),
            self.minimapView.widthAnchor.constraint(equalToConstant: 200.0),
            self.minimapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32.0),
            self.minimapView.heightAnchor.constraint(equalToConstant: 200.0)
        ])
    }
}
