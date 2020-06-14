import Foundation
import UIKit

class ObjectSelectorView: UIView {
    
    public var blurView: UIVisualEffectView!
    public var addObjectButton: UIButton!
    public var objectCategoryButtons: [ObjectSelectorCategoryButton] = []
    public var objectCategoryStackView: UIStackView!

    public init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = 18.0
        self.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .regular)
        self.blurView = UIVisualEffectView(effect: blurEffect)
        self.addSubview(blurView)
        self.layoutBlurView()
        
        self.addObjectButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.setTitle("Add Object", for: .normal)
            button.tintColor = .white
            return button
        }()
        self.addSubview(addObjectButton)
        self.layoutAddObjectButton()
        
        for objectCategory in Object.Category.allCases.sorted(by: { $0.displayName() < $1.displayName() }) {
            let objectCategoryButton = ObjectSelectorCategoryButton(for: objectCategory)
            self.objectCategoryButtons.append(objectCategoryButton)
        }
        
        self.objectCategoryStackView = {
            let stackView = UIStackView(arrangedSubviews: self.objectCategoryButtons)
            stackView.axis = .vertical
            return stackView
        }()
        self.addSubview(objectCategoryStackView)
        self.layoutObjectCategoryStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func closedHeight() -> CGFloat {
        return 36.0
    }
    
    public func openHeight() -> CGFloat {
        return 36.0 * CGFloat(Object.Category.allCases.count + 1) + 34.0
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
    
    private func layoutAddObjectButton() {
        self.addObjectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.addObjectButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.addObjectButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.addObjectButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            self.addObjectButton.heightAnchor.constraint(equalToConstant: 36.0)
        ])
    }
    
    private func layoutObjectCategoryStackView() {
        self.objectCategoryStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.objectCategoryStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.objectCategoryStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.objectCategoryStackView.bottomAnchor.constraint(equalTo: self.addObjectButton.topAnchor, constant: -8.0),
        ])
        NSLayoutConstraint.activate(self.objectCategoryStackView.arrangedSubviews.map { $0.heightAnchor.constraint(equalToConstant: 36.0) })
    }
}
 
