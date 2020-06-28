import Foundation
import UIKit

class FloorplanVisualizationObjectView: UIView {
    
    var object: Object
    private var categoryLabel: UILabel!
    
    public init(for object: Object) {
        self.object = object
        super.init(frame: .zero)
        
        self.layer.backgroundColor = UIColor.systemRed.withAlphaComponent(0.3).cgColor
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.systemRed.cgColor
        
        if self.object.category.placementCategory() != .wallBox2D {
            self.categoryLabel = {
                let label = UILabel()
                label.text = self.object.category.displayName()
                label.textColor = UIColor.systemRed
                label.font = label.font.withSize(24.0)
                return label
            }()
            self.addSubview(categoryLabel)
            self.layoutCategoryLabel()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutCategoryLabel() {
        self.categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.categoryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
