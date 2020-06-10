import Foundation
import UIKit

class ObjectSelectorViewController: UIViewController {
        
    public var objectSelectorView: ObjectSelectorView!
    
    private var heightConstraint: NSLayoutConstraint!
    private var selectorIsOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.objectSelectorView = ObjectSelectorView()
        self.view = objectSelectorView
        self.objectSelectorView.addObjectButton.addTarget(self, action: #selector(self.addObjectButtonDidTouchUpInside), for: .touchUpInside)
        
        self.heightConstraint = self.objectSelectorView.heightAnchor.constraint(equalToConstant: self.objectSelectorView.closedHeight())
        
        NSLayoutConstraint.activate([
            self.heightConstraint
        ])
    }
    
    public func open(animate: Bool) {
        self.selectorIsOpen = true
        if animate {
            self.heightConstraint.constant = self.objectSelectorView.openHeight()
            UIView.animate(withDuration: 0.2) {
                self.objectSelectorView.layoutIfNeeded()
            }
            UIView.transition(with: self.objectSelectorView.addObjectButton, duration: 0.2, animations: {
                self.objectSelectorView.addObjectButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                self.objectSelectorView.addObjectButton.setTitle("Cancel", for: .normal)
            }, completion: nil)
        } else {
            self.heightConstraint.constant = self.objectSelectorView.openHeight()
            self.objectSelectorView.addObjectButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            self.objectSelectorView.addObjectButton.setTitle("Cancel", for: .normal)
        }
    }
    
    public func close(animate: Bool) {
        self.selectorIsOpen = false
        if animate {
            self.heightConstraint.constant = self.objectSelectorView.closedHeight()
            UIView.animate(withDuration: 0.2) {
                self.objectSelectorView.layoutIfNeeded()
            }
            self.objectSelectorView.addObjectButton.setImage(UIImage(systemName: "plus"), for: .normal)
            self.objectSelectorView.addObjectButton.setTitle("Add Object", for: .normal)
        } else {
            self.heightConstraint.constant = self.objectSelectorView.closedHeight()
            self.objectSelectorView.addObjectButton.setImage(UIImage(systemName: "plus"), for: .normal)
            self.objectSelectorView.addObjectButton.setTitle("Add Object", for: .normal)
        }
    }
    
    @objc private func addObjectButtonDidTouchUpInside() {
        if self.selectorIsOpen {
            self.close(animate: false)
        } else {
            self.open(animate: false)
        }
    }
}
