import Foundation
import UIKit
import ARKit

class ScanRecorderViewController: UIViewController, ARSessionDelegate {
    
    private var scanRecorderView: ScanRecorderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanRecorderView = ScanRecorderView()
        self.view = self.scanRecorderView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.sceneReconstruction = .meshWithClassification
        config.environmentTexturing = .automatic

        self.scanRecorderView.arView.session.run(config)
        self.scanRecorderView.arView.session.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.parent?.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @objc private func backButtonDidTouchUpInside() {
        self.navigationController?.popViewController(animated: true)
    }
}
