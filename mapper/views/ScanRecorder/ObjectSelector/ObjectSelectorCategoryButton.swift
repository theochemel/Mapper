import Foundation
import UIKit

class ObjectSelectorCategoryButton: UIButton {
    
    public var category: Object.Category
    
    public init(for category: Object.Category) {
        self.category = category
        
        super.init(frame: .zero)
        
        self.setTitle(category.displayName(), for: .normal)
        self.tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
