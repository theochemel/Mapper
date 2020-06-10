import Foundation
import UIKit

class MinimapViewController: UIViewController {
    
    public var minimapView: MinimapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.minimapView = MinimapView()
        self.view = minimapView
    }
    
    public func update(from state: ScanState) {
        UIView.animate(withDuration: 0.05) {
            self.minimapView.cameraIndicatorView.transform = CGAffineTransform(rotationAngle: CGFloat(-state.cameraOrientation.y))
        }
    }
}
