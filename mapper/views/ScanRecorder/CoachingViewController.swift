import Foundation
import UIKit

class CoachingViewController: UIViewController {
    
    public var coachingView: CoachingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coachingView = CoachingView()
        self.view = coachingView
        self.coachingView.dismissButton.addTarget(self, action: #selector(self.dismissButtonDidTouchUpInside), for: .touchUpInside)
    }
    
    public func showMessage(_ message: String, animate: Bool) {
        self.coachingView.messageLabel.text = message
        self.show(animate: animate)
    }
    
    public func show(animate: Bool) {
        if animate {
            UIView.animate(withDuration: 0.2) {
                self.coachingView.alpha = 1.0
            }
        } else {
            self.coachingView.alpha = 1.0
        }
    }
    
    public func hide(animate: Bool) {
        if animate {
            UIView.animate(withDuration: 0.2) {
                self.coachingView.alpha = 0.0
            }
        } else {
            self.coachingView.alpha = 0.0
        }
    }
    
    @objc private func dismissButtonDidTouchUpInside() {
        self.hide(animate: true)
    }
}
